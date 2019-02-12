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

    private double[][] values; ///The values of elevation for each tile in the elevation map
    private double maxSlope; ///The maximum slope between two points; determines the levelledness of the map
                             ///If negative, then there is no maximum slope

    /**
     * Constructs a new ElevationMap
     * with the given number of rows and columns
     * Creates the map flat, at a default value of 1 elevation
     */
    this(int rows, int cols, double maxSlope) {
        for(int i = 0; i < rows; i++) {
            this.values ~= null;
            for(int j = 0; j < cols; j++) {
                this.values[i] ~= 0;
            }
        }
        this.maxSlope = maxSlope;
    }

    /**
     * Sets the value at the given coordinates 
     * Properly levels the map afterward
     */
    void set(int row, int col, double value) {
        this.values[row][col] = value;
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
     */
    void level() {
        if(this.maxSlope < 0) {
            return;
        }
        bool allLevel = false;
        while(!allLevel) {
            allLevel = true;
            for(int i = 0; i < this.values.length; i++) {
                for(int j = 0; i < this.values[j].length; j++) {
                    //Left
                    if(i > 0 && this.values[i][j] - this.values[i - 1][j] > this.maxSlope) {
                        double shift = (abs(this.values[i][j] - this.values[i - 1][j]) - this.maxSlope) / 2;
                        this.values[i][j] = this.values[i][j] - shift;
                        this.values[i - 1][j] = this.values[i - 1][j] + shift;
                        allLevel = false;
                    }
                    //Right
                    if(i < this.values.length - 1 && this.values[i][j] - this.values[i + 1][j] > this.maxSlope) {
                        double shift = (abs(this.values[i][j] - this.values[i + 1][j]) - this.maxSlope) / 2;
                        this.values[i][j] = this.values[i][j] - shift;
                        this.values[i + 1][j] = this.values[i + 1][j] + shift;
                        allLevel = false;
                    }
                    //Up
                    if(j > 0 && this.values[i][j] - this.values[i][j - 1] > this.maxSlope) {
                        double shift = (abs(this.values[i][j] - this.values[i][j - 1]) - this.maxSlope) / 2;
                        this.values[i][j] = this.values[i][j] - shift;
                        this.values[i][j - 1] = this.values[i][j - 1] + shift;
                        allLevel = false;
                    }
                    //Down
                    if(j < this.values[i].length && this.values[i][j] - this.values[i][j + 1] > this.maxSlope) {
                        double shift = (abs(this.values[i][j] - this.values[i][j + 1]) - this.maxSlope) / 2;
                        this.values[i][j] = this.values[i][j] - shift;
                        this.values[i][j + 1] = this.values[i][j + 1] + shift;
                        allLevel = false;
                    }
                }
            }
        }
    }

}