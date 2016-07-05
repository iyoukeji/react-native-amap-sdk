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
    latitude: 38.89,
    longitude: 121.58,
  };

  render() {
    return (
      <AMapView style={styles.container} compassEnabled={true}
        defaultRegion={{"latitude": 38.89, "longitude": 121.58, "latitudeDelta": 0.5, "longitudeDelta": 0.5}}
        region={{"latitude": this.state.latitude, "longitude": this.state.longitude, "latitudeDelta": 0.5, "longitudeDelta": 0.5}}
        onRegionChange={(e) => console.log(e)}
        onUpdateLocation={e => console.log(e)}
        myLocationEnabled={true}
        myLocationButtonEnabled={true}>
        <AMapView.Annotation coordinate={{"latitude": 38.89, "longitude": 121.58}}
          title="aaa" subtitle="bbbb" enabled={true} selected={true} canShowCallout={true}
          onSelect={e => console.log(e)}>
          <AMapView.Callout>
            <View style={{ width: 100, height: 40, backgroundColor: '#ffffff'}}>
              <Text>aaaaaabbbbb</Text>
            </View>
          </AMapView.Callout>
        </AMapView.Annotation>
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
