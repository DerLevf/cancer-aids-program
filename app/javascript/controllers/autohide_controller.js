import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Sets the default delay to 4000ms (4 seconds)
  static values = { delay: { type: Number, default: 4000 } }

  connect() {
    // This runs as soon as the element is added to the DOM (via page load OR Turbo stream)
    
    // Set a timeout to start the fade effect
    this.fadeTimeout = setTimeout(() => {
      this.element.style.opacity = '0'; // Start the CSS transition (fade out)
    }, this.delayValue); 

    // Set a second timeout to remove the element completely after the fade is done
    this.removeTimeout = setTimeout(() => {
      this.element.remove(); // Remove from DOM
    }, this.delayValue + 500); // 4000ms delay + 500ms fade duration
  }

  disconnect() {
    // Clean up timers if the user navigates away before the alert disappears
    clearTimeout(this.fadeTimeout);
    clearTimeout(this.removeTimeout);
  }
}