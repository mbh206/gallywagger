// app/javascript/application.js
import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener("DOMContentLoaded", function () {
    const teamButtons = document.querySelectorAll(".team-button");
    const submitButton = document.getElementById("submit-predictions");
    const form = document.getElementById("prediction-form");
  
    // Object to keep track of selected teams
    const selectedTeams = {};
  
    // Toggle team selection
    teamButtons.forEach((button) => {
      button.addEventListener("click", () => {
        const gameId = button.getAttribute("data-game-id");
        const team = button.getAttribute("data-team");
  
        // Toggle button state
        teamButtons.forEach((btn) => {
          if (btn.getAttribute("data-game-id") === gameId) {
            btn.classList.remove("selected");
          }
        });
        button.classList.add("selected");
  
        // Store the selected team for the game
        selectedTeams[gameId] = team;
      });
    });
  
    // Form submission handler
    submitButton.addEventListener("click", (event) => {
      event.preventDefault();
  
      // Check if all games have a team selected
      const gameBlocks = document.querySelectorAll(".game-block");
      let allGamesSelected = true;
  
      gameBlocks.forEach((gameBlock) => {
        const gameId = gameBlock.getAttribute("data-game-id");
        if (!selectedTeams[gameId]) {
          allGamesSelected = false;
          gameBlock.classList.add("error"); // Optional: Highlight the game block with no selection
        } else {
          gameBlock.classList.remove("error");
        }
      });
  
      if (allGamesSelected) {
        // Add selected teams as hidden inputs before submitting
        Object.keys(selectedTeams).forEach((gameId) => {
          const input = document.createElement("input");
          input.type = "hidden";
          input.name = `predictions[${gameId}]`;
          input.value = selectedTeams[gameId];
          form.appendChild(input);
        });
  
        // Submit the form
        form.submit();
      } else {
        alert("Please select a team for each game before submitting.");
      }
    });
  });

  
  
  function updateGameStatuses() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  
    fetch('/games/update_statuses', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      }
    })
    .then(response => {
      if (!response.ok) {
        console.error('Failed to update game statuses');
      }
    })
    .catch(error => {
      console.error('Error updating game statuses:', error);
    });
  }
  
  // Call this function every minute
  setInterval(updateGameStatuses, 60000); // 60000 ms = 1 minute
  