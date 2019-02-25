module watershed.graphics.MainActivity;

import watershed;

/**
 * The main activity that handles the main display and events
 * of the watershed model
 */
class MainActivity : Activity {

    ElevMapComponent map; ///The map component part of the activity

    /**
     * Constructs a new main activity
     * Initializes the contained components
     */
    this(Display container) {
        super(container);
        this.map = new ElevMapComponent(container, new iRectangle(50, 50, 500, 400), 50, Color(0, 110, 30), Color(160, 160, 160));
        this.components ~= this.map;
    }

}