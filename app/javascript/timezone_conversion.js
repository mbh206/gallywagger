document.addEventListener("turbo:load", () => {
    console.log("Turbo loaded, game times should now be converted.");
    const gameTimes = document.querySelectorAll('.game-time');

    gameTimes.forEach(gameTime => {
        const utcTime = gameTime.getAttribute('data-utc-time');
        if (utcTime) {
            const localTime = new Date(utcTime).toLocaleString();
            gameTime.textContent = `local time: ${localTime}`;
        }
    });
});