module app;

import watershed;

void main() {
	Display display = new Display(700, 400);
    display.activity = new MainActivity(display);
    display.run();
}
