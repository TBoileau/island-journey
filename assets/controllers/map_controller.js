import { Controller } from '@hotwired/stimulus';
import { Loader } from "@googlemaps/js-api-loader";

/**
 * @class MapController
 */
export default class extends Controller {
    connect() {
        this.loader = new Loader({
            apiKey: this.element.dataset.apikey,
        });

        this.loader.load()
          .then(this.loadMap.bind(this))
          .then(this.loadActivities.bind(this))
        ;
    }

    loadMap() {
        this.map = new google.maps.Map(this.element, {
            center: { lat: 64.87358158140388, lng: -18.281253127873043 },
            zoom: 7,
        });
    }

    loadActivities() {
        const infoWindow = new google.maps.InfoWindow();

        fetch('/api/activities', {
            headers: {
                'Accept': 'application/json',
            }
        })
          .then(response => response.json())
          .then(activites => {
              activites.forEach(activity => {
                  const marker = new google.maps.Marker({
                      position: { lat: activity.lat, lng: activity.lng },
                      map: this.map,
                      title: activity.name,
                  });
                  marker.addListener('click', () => {
                      infoWindow.close();
                      infoWindow.setContent(`
                          <div class="activity">
                              <h2>${activity.name}</h2>
                              <div>${activity.description}</div>
                          </div>
                      `);
                      infoWindow.open(marker.getMap(), marker);
                  });
              });
          })
        ;
    }
}
