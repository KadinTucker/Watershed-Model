module watershed.graphics.MainActivity;

import watershed;

/**
 * The main activity that handles the main display and events
 * of the watershed model
 */
class MainActivity : Activity {

    ElevationMap elevMap; ///The array representing the elevation at each quantized tile location

    /**
     * Constructs a new main activity
     * Initializes the elevation map
     */
    this(Display container) {
        super(container);
        elevMap = new ElevationMap(30, 40, 0.5);
    }

}