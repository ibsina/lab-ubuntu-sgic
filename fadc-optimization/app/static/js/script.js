function fetchData() {
    fetch('/api/data')
        .then(response => response.json())
        .then(data => {
            const dataDiv = document.getElementById("data");
            dataDiv.textContent = data.message;
            dataDiv.style.color = "#0d6efd";
        })
        .catch(err => {
            document.getElementById("data").textContent = "Error loading data.";
        });
}

// Fetch immediately and every 3 seconds
window.addEventListener("load", () => {
    fetchData();
    setInterval(fetchData, 3000);
});

