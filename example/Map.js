/**
 * Created by chenjunsheng on 16/7/17.
 * @flow
 */
'use strict';

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableHighlight,
} from 'react-native';
import { AMapView, AMapLocationManager } from 'react-native-amap-sdk';

export default class Map extends Component {
    state = {
        showCallout: false,
        latitude: 41.1,
        longitude: 118.1,
    };

    render() {
        return (
            <View style={{ flex: 1 }}>
                <AMapView style={styles.container} compassEnabled={true}
                          defaultRegion={{"latitude": this.state.latitude, "longitude": this.state.longitude, "latitudeDelta": 0.5, "longitudeDelta": 0.5}}
                          region={{"latitude": this.state.latitude, "longitude": this.state.longitude, "latitudeDelta": 0.5, "longitudeDelta": 0.5}}
                          myLocationEnabled={true}
                          onMove={(e) => {
                              console.log("Map::onMove", e.nativeEvent ? e.nativeEvent : e);
                          }}
                          onRegionChange={(e) => {
                              console.log("Map::onRegionChange", e.nativeEvent ? e.nativeEvent : e);
                          }}
                >
                    <AMapView.Annotation coordinate={{"latitude": this.state.latitude, "longitude": this.state.longitude}}
                                         title="aaa" subtitle="bbbb" enabled={true} selected={true} canShowCallout={true}
                                         onSelect={e => console.log(e)}>
                        <AMapView.Callout>
                            <View style={{ width: 100, height: 40, backgroundColor: '#ffffff'}}>
                                <Text>aaaaaabbbbb</Text>
                            </View>
                        </AMapView.Callout>
                    </AMapView.Annotation>
                </AMapView>
                <View style={{flex: 1, justifyContent: 'center'}}>
                    <TouchableHighlight onPress={() => {
                        AMapLocationManager.requestCurrentLocation(3, 10, 10)
                        .then(location => {
                            console.log('requestCurrentLocation', location)
                            this.setState({"latitude": location.latitude, "longitude": location.longitude});
                        })
                        .catch(err => console.log(err));
                            {/*AMapLocationManager.startUpdatingLocation(false, location => {*/}
                              {/*console.log('startUpdatingLocation', location);*/}
                              {/*this.setState({"latitude": location.latitude, "longitude": location.longitude});*/}
                            {/*});*/}
                    }}>
                        <Text>动作</Text>
                    </TouchableHighlight>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
});
