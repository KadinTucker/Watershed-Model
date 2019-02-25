module watershed.graphics.ElevMapComponent;

import watershed;

class ElevMapComponent : Component {

    ElevationMap elevMap; ///The elevation map used in this activity
    iRectangle _location; ///The location and dimensions of the component
    int cellSize; ///The size (side length) of each elevation cell
    Color minColor; ///The color for the minimum elevation
    Color maxColor; ///The color for the maximum elevation
    Texture drawTexture; ///The surface to draw for the component

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
        this.updateTexture();
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
     * Updates the draw texture contained
     */
    private void updateTexture() {
        Surface drawSurface = new Surface(this.elevMap.elevation.length * this.cellSize, 
                this.elevMap.elevation[0].length * this.cellSize);
        for(int i = 0; i < this.elevMap.elevation.length; i++) {
            for(int j = 0 ; j < this.elevMap.elevation[i].length; j++) {
                drawSurface.drawColor = this.getColorFromValue(this.elevMap.elevation[i][j]);
                drawSurface.fill(new iRectangle(i * this.cellSize, j * this.cellSize,
                        this.cellSize, this.cellSize));
            }
        }
        this.drawTexture = new Texture(drawSurface, this.container.renderer);
    }

    /**
     * The draw method of the component
     * Draws the map according to the boundaries and cell size
     */
    override void draw() {
        this.container.renderer.copy(this.drawTexture, this._location.initialPoint.x, this._location.initialPoint.y);
    }

    /**
     * Handles all events on the sceen
     * To be done
     */
    void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
        }
    }

}