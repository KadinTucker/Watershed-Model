module watershed.logic.ElevationMap;

import watershed;

import std.math;
import std.random;

/**
 * A class representing a map of tile-based elevation elevation
 * Elevation elevation are not necessarily elevations, but a representation
 * of tendencies; objects in the "watershed" tend to go to lower elevation
 * Could also represent energy levels in science, or possibly human choices
 * The map can collect statistics on the elevation elevation, as well as 
 * perform operations on the whole map
 */
class ElevationMap {

    private double[][] _elevation; ///The elevation of elevation for each tile in the elevation map
    private double[][] _water; ///The amount of 'water' on each tile
    private double maxSlope; ///The maximum slope between two points; determines the levelledness of the map
                             ///If negative, then there is no maximum slope
    double max; ///The maximum value in the map
    double min; ///The minimum value in the map

    /**
     * Constructs a new ElevationMap
     * with the given number of rows and columns
     * Creates the map flat, at a default value of 1 elevation
     */
    this(int rows, int cols, double maxSlope) {
        for(int i = 0; i < rows; i++) {
            this._elevation ~= null;
            for(int j = 0; j < cols; j++) {
                this._elevation[i] ~= uniform!"(]"(0.0, 4 * maxSlope);
            }
        }
        for(int i = 0; i < rows; i++) {
            this._water ~= null;
            for(int j = 0; j < cols; j++) {
                this._water[i] ~= 0.0;
            }
        }
        this.maxSlope = maxSlope;
        this.max = this.maximum();
        this.min = this.minimum();
    }

    /**
     * Returns the elevation
     */
    @property double[][] elevation() {
        return this._elevation;
    }

    /**
     * Sets the value at the given coordinates 
     * Properly levels the map afterward
     */
    void set(int row, int col, double value) {
        this._elevation[row][col] = value;
        this.level();
    }

    /**
     * Sets the maximum slope amount for the map
     * Adjusts the level of the map in order to keep it consistent
     */
    void setMaxSlope(double maxSlope) {
        this.maxSlope = maxSlope;
        this.level();
    }

    /**
     * Levels the elevation map by ensuring that all elevation
     * are consistent with the sloping standards
     * Also updates the maximum and minimum
     * TODO: Fix infinite looping
     */
    void level() {
        this.max = this.maximum();
        this.min = this.minimum();
        if(this.maxSlope < 0) {
            return;
        }
        bool allLevel = false;
        while(!allLevel) {
            allLevel = true;
            for(int i = 0; i < this._elevation.length; i++) {
                for(int j = 0; j < this._elevation[i].length; j++) {
                    //Left
                    if(i > 0 && this._elevation[i][j] - this._elevation[i - 1][j] > this.maxSlope) {
                        double shift = (abs(this._elevation[i][j] - this._elevation[i - 1][j]) - this.maxSlope) / 2;
                        this._elevation[i][j] = this._elevation[i][j] - shift;
                        this._elevation[i - 1][j] = this._elevation[i - 1][j] + shift;
                        allLevel = false;
                    }
                    //Right
                    if(i < this._elevation.length - 1 && this._elevation[i][j] - this._elevation[i + 1][j] > this.maxSlope) {
                        double shift = (abs(this._elevation[i][j] - this._elevation[i + 1][j]) - this.maxSlope) / 2;
                        this._elevation[i][j] = this._elevation[i][j] - shift;
                        this._elevation[i + 1][j] = this._elevation[i + 1][j] + shift;
                        allLevel = false;
                    }
                    //Up
                    if(j > 0 && this._elevation[i][j] - this._elevation[i][j - 1] > this.maxSlope) {
                        double shift = (abs(this._elevation[i][j] - this._elevation[i][j - 1]) - this.maxSlope) / 2;
                        this._elevation[i][j] = this._elevation[i][j] - shift;
                        this._elevation[i][j - 1] = this._elevation[i][j - 1] + shift;
                        allLevel = false;
                    }
                    //Down
                    if(j < this._elevation[i].length - 1 && this._elevation[i][j] - this._elevation[i][j + 1] > this.maxSlope) {
                        double shift = (abs(this._elevation[i][j] - this._elevation[i][j + 1]) - this.maxSlope) / 2;
                        this._elevation[i][j] = this._elevation[i][j] - shift;
                        this._elevation[i][j + 1] = this._elevation[i][j + 1] + shift;
                        allLevel = false;
                    }
                }
            }
        }
    }

    /**
     * Returns the minimum value of elevation on the map
     */
    private double minimum() {
        double min = this._elevation[0][0];
        foreach(row; this._elevation) {
            foreach(value; row) {
                if(value < min) {
                    min = value;
                }
            }
        }
        return min;
    }

    /**
     * Returns the minimum value of elevation on the map
     */
    private double maximum() {
        double max = this._elevation[0][0];
        foreach(row; this._elevation) {
            foreach(value; row) {
                if(value > max) {
                    max = value;
                }
            }
        }
        return max;
    }

    /**
     * Sets all of the water on the map to be the given amount
     */
    void setAll(double amount) {
        for(int i = 0; i < this._water.length; i++) {
            for(int j = 0; j < this._water[i].length; j++) {
                this._water[i][j] = amount; 
            }
        }
    }

    /**
     * Adds the given amount of water to a tile
     */
    void addWater(int row, int col, double amount) {
        this._water[row][col] += amount;
    }

    /**
     * Sets the given amount of water on a tile
     */
    void setWater(int row, int col, double amount) {
        this._water[row][col] = amount;
    }

    /**
     * Runs a time step on the watershed model
     * All water flows downhill from each tile
     * Stores the temporary list of the next state of water values
     * in order to avoid repetition
     * TODO:
     */
    void runTimestep() {
        double[][] newWater = this._water.dup;

        this._water = newWater;
    }

}