package com.starlight36.react.amap;

import android.content.Context;

import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.BitmapDescriptorFactory;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Marker;
import com.amap.api.maps.model.MarkerOptions;
import com.facebook.react.views.view.ReactViewGroup;

public class ReactAMapAnnotationView extends ReactAMapFeatureView<Marker> {

    private MarkerOptions markerOptions;
    private Marker marker;

    private String image;
    private String title;
    private String subtitle;
    private float pinColor = 0.0f;
    private boolean canShowCallout;
    private Float anchorX;
    private Float anchorY;
    private Integer calloutAnchorX;
    private Integer calloutAnchorY;
    private boolean enabled;
    private boolean highlighted;
    private boolean selected;
    private boolean draggable;
    private LatLng position;

    private boolean hasCallout = false;

    public ReactAMapAnnotationView(Context context) {
        super(context);
    }

    @Override
    public void addToAMapView(ReactAMapView view) {
        this.marker = view.getMap().addMarker(getMarkerOptions());
    }

    @Override
    public void removeFromAMapView(ReactAMapView view) {
        marker.remove();
    }

    @Override
    public Marker getFeature() {
        return marker;
    }

    public MarkerOptions getMarkerOptions() {
        if (markerOptions == null) {
            markerOptions = createMarkerOptions();
        }
        return markerOptions;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public void setTitle(String title) {
        this.title = title;
        if (marker != null) {
            marker.setTitle(title);
        }
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
        if (marker != null) {
            marker.setSnippet(subtitle);
        }
    }

    public void setPinColor(float pinColor) {
        this.pinColor = pinColor;
        if (marker != null) {
            marker.setIcon(getIcon());
        }
    }

    public void setCanShowCallout(boolean canShowCallout) {
        this.canShowCallout = canShowCallout;
    }

    public void setAnchor(Float anchorX, Float anchorY) {
        this.anchorX = anchorX;
        this.anchorY = anchorY;
        if (marker != null) {
            marker.setAnchor(anchorX, anchorY);
        }
    }

    public void setCalloutAnchorX(Integer calloutAnchorX, Integer calloutAnchorY) {
        this.calloutAnchorX = calloutAnchorX;
        this.calloutAnchorY = calloutAnchorY;
    }

    @Override
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public void setHighlighted(boolean highlighted) {
        this.highlighted = highlighted;
    }

    @Override
    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    public void setDraggable(boolean draggable) {
        this.draggable = draggable;
        if (marker != null) {
            marker.setDraggable(draggable);
        }
    }

    public void setPosition(LatLng position) {
        this.position = position;
        if (marker != null) {
            marker.setPosition(position);
        }
    }

    private MarkerOptions createMarkerOptions() {
        MarkerOptions options = new MarkerOptions().position(position);
        if (anchorX != null && anchorY != null) {
            options.anchor(anchorX, anchorY);
        }
        if (calloutAnchorX != null && calloutAnchorY != null) {
            options.setInfoWindowOffset(calloutAnchorX, calloutAnchorY);
        }
        options.title(title);
        options.snippet(subtitle);
        options.draggable(draggable);
        options.visible(true);
        options.icon(getIcon());
        return options;
    }

    private BitmapDescriptor getIcon() {
//        if (hasCallout) {
//            // creating a bitmap from an arbitrary view
//            return BitmapDescriptorFactory.fromBitmap(createDrawable());
//        } else if (iconBitmapDescriptor != null) {
//            // use local image as a marker
//            return iconBitmapDescriptor;
//        } else {
        return BitmapDescriptorFactory.defaultMarker(this.pinColor);
//        }
    }

}
