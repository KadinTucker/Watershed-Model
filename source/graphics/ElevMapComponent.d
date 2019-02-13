module watershed.graphics.ElevMapComponent;

import watershed;

class ElevMapComponent : Component {

    ElevationMap elevMap; ///The elevation map used in this activity
    iRectangle _location; ///The location and dimensions of the component
    int cellSize; ///The size (side length) of each elevation cell
    Color minColor; ///The color for the minimum elevation
    Color maxColor; ///The color for the maximum elevation

    /**
     * Constructs a new map component
     * Initializes the elevation map
     */
    this(Display container, iRectangle location, int cellSize, Color minColor, Color maxColor) {
        super(container);
        elevMap = new ElevationMap(30, 40, 0.5);
        this._location = location;
        this.cellSize = cellSize;
        this.minColor = minColor;
        this.maxColor = maxColor;
    }

    /**
     * Returns the component's location
     */
    override @property iRectangle location() {
        return this._location;
    }

    @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Gets the color to draw based on the given value
     * relative to the contained map and colorscale
     */
    Color getColorFromValue(double value) {
        double scale = (value - this.elevMap.min) / this.elevMap.max;
        return Color(cast(ubyte) (this.minColor.r + (this.maxColor.r - this.minColor.r) * scale),
                cast(ubyte) (this.minColor.g + (this.maxColor.g - this.minColor.g) * scale),
                cast(ubyte) (this.minColor.b + (this.maxColor.b - this.minColor.b) * scale));
    }

    /**
     * The draw method of the component
     * Draws the map according to the boundaries and cell size
     */
    override void draw() {
        for(int i = 0; i < this.elevMap.values.length; i++) {
            for(int j = 0 ; j < this.elevMap.values[i].length; j++) {
                this.container.renderer.drawColor = this.getColorFromValue(this.elevMap.values[i][j]);
                this.container.renderer.fill(new iRectangle(
                    this._location.initialPoint.x + i * this.cellSize,
                    this._location.initialPoint.y + j * this.cellSize,
                    this.cellSize, this.cellSize));
            }
        }
    }

    /**
     * Handles all events on the sceen
     * To be done
     */
    void handleEvent(SDL_Event event) {

    }

}