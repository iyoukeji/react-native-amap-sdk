/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
} from 'react-native';
import { AMapView, AMapLocationManager } from 'react-native-amap-all';

class Example extends Component {
  state = {
    showCallout: false,
    latitude: 41.0,
    longitude: 118.0,
  };

  render() {
    return (
      <AMapView style={styles.container} compassEnabled={true}
        defaultRegion={{"latitude": 41.0, "longitude": 118.0, "latitudeDelta": 0.5, "longitudeDelta": 0.5}}
        region={{"latitude": this.state.latitude, "longitude": this.state.longitude, "latitudeDelta": 0.5, "longitudeDelta": 0.5}}
        myLocationEnabled={true}>
        <AMapView.Annotation coordinate={{"latitude": 41.0, "longitude": 118.0}}
          title="aaa" subtitle="bbbb" enabled={true} selected={true} canShowCallout={true}
          onSelect={e => console.log(e)} />
      </AMapView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

AppRegistry.registerComponent('Example', () => Example);
