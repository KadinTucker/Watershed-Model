module watershed.logic.ElevationMap;

import watershed;

import std.math;

/**
 * A class representing a map of tile-based elevation values
 * Elevation values are not necessarily elevations, but a representation
 * of tendencies; objects in the "watershed" tend to go to lower elevation
 * Could also represent energy levels in science, or possibly human choices
 * The map can collect statistics on the elevation values, as well as 
 * perform operations on the whole map
 */
class ElevationMap {

    private double[][] _values; ///The values of elevation for each tile in the elevation map
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
            this._values ~= null;
            for(int j = 0; j < cols; j++) {
                this._values[i] ~= 0;
            }
        }
        this.maxSlope = maxSlope;
    }

    /**
     * Returns the values
     */
    @property double[][] values() {
        return this._values;
    }

    /**
     * Sets the value at the given coordinates 
     * Properly levels the map afterward
     */
    void set(int row, int col, double value) {
        this._values[row][col] = value;
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
     * Levels the elevation map by ensuring that all values
     * are consistent with the sloping standards
     * Also updates the maximum and minimum
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
            for(int i = 0; i < this._values.length; i++) {
                for(int j = 0; i < this._values[j].length; j++) {
                    //Left
                    if(i > 0 && this._values[i][j] - this._values[i - 1][j] > this.maxSlope) {
                        double shift = (abs(this._values[i][j] - this._values[i - 1][j]) - this.maxSlope) / 2;
                        this._values[i][j] = this._values[i][j] - shift;
                        this._values[i - 1][j] = this._values[i - 1][j] + shift;
                        allLevel = false;
                    }
                    //Right
                    if(i < this._values.length - 1 && this._values[i][j] - this._values[i + 1][j] > this.maxSlope) {
                        double shift = (abs(this._values[i][j] - this._values[i + 1][j]) - this.maxSlope) / 2;
                        this._values[i][j] = this._values[i][j] - shift;
                        this._values[i + 1][j] = this._values[i + 1][j] + shift;
                        allLevel = false;
                    }
                    //Up
                    if(j > 0 && this._values[i][j] - this._values[i][j - 1] > this.maxSlope) {
                        double shift = (abs(this._values[i][j] - this._values[i][j - 1]) - this.maxSlope) / 2;
                        this._values[i][j] = this._values[i][j] - shift;
                        this._values[i][j - 1] = this._values[i][j - 1] + shift;
                        allLevel = false;
                    }
                    //Down
                    if(j < this._values[i].length && this._values[i][j] - this._values[i][j + 1] > this.maxSlope) {
                        double shift = (abs(this._values[i][j] - this._values[i][j + 1]) - this.maxSlope) / 2;
                        this._values[i][j] = this._values[i][j] - shift;
                        this._values[i][j + 1] = this._values[i][j + 1] + shift;
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
        double min = this._values[0][0];
        foreach(row; this._values) {
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
        double max = this._values[0][0];
        foreach(row; this._values) {
            foreach(value; row) {
                if(value > max) {
                    max = value;
                }
            }
        }
        return max;
    }

}