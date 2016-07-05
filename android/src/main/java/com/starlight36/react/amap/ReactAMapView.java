package com.starlight36.react.amap;

import android.content.Context;
import android.location.Location;
import android.view.View;

import com.amap.api.maps.AMap;
import com.amap.api.maps.AMapOptions;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.MapView;
import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.LatLngBounds;
import com.amap.api.maps.model.Marker;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReactAMapView extends MapView implements LifecycleEventListener {

    private final AMapOptions options = new AMapOptions();
    private final ReactContext reactContext;
    private final List<ReactAMapFeatureView> features = new ArrayList<>();
    private final Map<Marker, ReactAMapAnnotationView> annotationViewMap = new HashMap<>();

    private boolean mapLoaded = false;
    private LatLngBounds defaultBounds;

    public ReactAMapView(Context context) {
        super(context);
        this.reactContext = (ReactContext) getContext();
        this.getMapFragmentDelegate().setOptions(this.options);
        this.setListeners();
    }

    public AMapOptions getAMapOptions() {
        return this.options;
    }

    @Override
    public void onHostResume() {
        this.onResume();
    }

    @Override
    public void onHostPause() {
        this.onPause();
    }

    @Override
    public void onHostDestroy() {
        this.onDestroy();
    }

    public void setDefaultRegion(double latitude, double longitude, double latitudeDelta, double longitudeDelta) {
        this.defaultBounds = new LatLngBounds(
                new LatLng(latitude - latitudeDelta / 2, longitude - longitudeDelta / 2),
                new LatLng(latitude + latitudeDelta / 2, longitude + longitudeDelta / 2)
        );
    }

    public void setRegion(double latitude, double longitude, double latitudeDelta, double longitudeDelta) {
        if (!mapLoaded) return;

        LatLngBounds bounds = new LatLngBounds(
                new LatLng(latitude - latitudeDelta / 2, longitude - longitudeDelta / 2),
                new LatLng(latitude + latitudeDelta / 2, longitude + longitudeDelta / 2)
        );

        this.getMap().moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, 0));
    }

    public void addFeature(View view, int index) {
        if (view instanceof ReactAMapAnnotationView) {
            ReactAMapAnnotationView annotationView = (ReactAMapAnnotationView) view;
            annotationView.addToAMapView(this);
            features.add(index, annotationView);
            annotationViewMap.put(annotationView.getFeature(), annotationView);
        }
    }

    public int getFeatureCount() {
        return features.size();
    }

    public View getFeatureAt(int index) {
        return features.get(index);
    }

    public void removeFeatureAt(int index) {
        ReactAMapFeatureView featureView = features.remove(index);
        featureView.removeFromAMapView(this);
        if (featureView instanceof ReactAMapAnnotationView) {
            annotationViewMap.remove(featureView);
        }
    }

    private void setListeners() {
        // 地图加载完成监听器
        this.getMap().setOnMapLoadedListener(new AMap.OnMapLoadedListener() {
            @Override
            public void onMapLoaded() {
                mapLoaded = true;
                getMap().moveCamera(CameraUpdateFactory.newLatLngBounds(defaultBounds, 0));
            }
        });

        // 可视区域改变的监听器
        this.getMap().setOnCameraChangeListener(new AMap.OnCameraChangeListener() {
            @Override
            public void onCameraChange(CameraPosition cameraPosition) {}

            @Override
            public void onCameraChangeFinish(CameraPosition cameraPosition) {
                LatLng center = cameraPosition.target;
                LatLngBounds bounds = getMap().getProjection().getVisibleRegion().latLngBounds;
                WritableMap event = Arguments.createMap();
                WritableMap region = Arguments.createMap();
                region.putDouble("latitude", center.latitude);
                region.putDouble("longitude", center.longitude);
                region.putDouble("latitudeDelta", Math.abs((bounds.northeast.latitude - bounds.southwest.latitude) / 2));
                region.putDouble("longitudeDelta", Math.abs((bounds.northeast.longitude - bounds.southwest.longitude) / 2));
                event.putMap("region", region);
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                        getId(),
                        "topRegionChange",
                        event
                );
            }
        });

        // 标记选中监听器
        this.getMap().setOnMarkerClickListener(new AMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                return false;
            }
        });

        // 当前位置改变监听器
        this.getMap().setOnMyLocationChangeListener(new AMap.OnMyLocationChangeListener() {
            @Override
            public void onMyLocationChange(Location location) {
                WritableMap event = Arguments.createMap();
                WritableMap userLocation = Arguments.createMap();
                WritableMap coordinate = Arguments.createMap();
                coordinate.putDouble("latitude", location.getLatitude());
                coordinate.putDouble("longitude", location.getLongitude());
                userLocation.putMap("coordinate", coordinate);
                event.putMap("userLocation", userLocation);
                event.putBoolean("updatingLocation", true);
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                        getId(),
                        "topUpdateLocation",
                        event
                );
            }
        });
    }
}
