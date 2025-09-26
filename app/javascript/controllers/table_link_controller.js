import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // This method runs when a click occurs on an element with data-action="click->table-link#navigate"
  navigate(event) {
    // 1. Check if the click originated from an interactive element (link, button)
    // We check for <a>, <button>, or any element inside an element with [data-confirm]
    if (event.target.closest('a') || 
        event.target.closest('button') || 
        event.target.closest('[data-confirm]')) {
      
      // If it's a link or button, let the default action proceed
      return;
    }

    // 2. Get the href from the data attribute on the row element
    const href = event.currentTarget.dataset.href;

    // 3. Navigate the window to the URL
    if (href) {
      window.location = href;
    }
  }
}