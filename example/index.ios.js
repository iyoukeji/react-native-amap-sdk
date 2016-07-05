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
      <View style={{ flex: 1 }}>
        <AMapView style={styles.container} compassEnabled={true}
          defaultRegion={{"latitude": 41.0, "longitude": 118.0, "latitudeDelta": 0.5, "longitudeDelta": 0.5}}
          region={{"latitude": this.state.latitude, "longitude": this.state.longitude, "latitudeDelta": 0.5, "longitudeDelta": 0.5}}
          myLocationEnabled={true}>
          <AMapView.Annotation coordinate={{"latitude": 41.0, "longitude": 118.0}}
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
            AMapLocationManager.requestCurrentLocation(2, 10, 10)
              .then(location => console.log(location))
              .catch(err => console.log(err));
            // AMapLocationManager.startUpdatingLocation(false, location => console.log(location));
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

AppRegistry.registerComponent('Example', () => Example);
