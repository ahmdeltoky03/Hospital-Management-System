function updateInputField() {
    const filter = document.getElementById("filter").value; // Get the selected filter
    const textInput = document.getElementById("textInput"); // Text input element
    const dropdownInput = document.getElementById("dropdownInput"); // Dropdown input element
    const dropdownInput1 = document.getElementById("dropdownInput1"); // Dropdown input element
    const dropdownInput2 = document.getElementById("dropdownInput2"); // Dropdown input element
    const dropdownInput3 = document.getElementById("dropdownInput3"); // Dropdown input element
    const dropdownRoom = document.getElementById("dropdownRoom"); // Dropdown input element
    const dropdownBed = document.getElementById("dropdownBed"); // Dropdown input element

    // Toggle visibility based on the selected filter
    if (filter == "getAll") {
        textInput.style.display = "none";
        dropdownInput.style.display = "none";
        dropdownInput1.style.display = "none";
        dropdownInput2.style.display = "none";
        dropdownInput3.style.display = "none";
        dropdownRoom.style.display = "none";
        dropdownBed.style.display = "none";
    }
    else if (filter == "Date Of Birth") {
        textInput.style.display = "none";
        dropdownInput.style.display = "none";
        dropdownInput1.style.display = "inline";
        dropdownInput2.style.display = "inline";
        dropdownInput3.style.display = "inline";
        dropdownRoom.style.display = "none";
        dropdownBed.style.display = "none";
    }
    else if (filter == "isWorking" || filter == "Gender") {
        textInput.style.display = "none";
        dropdownInput.style.display = "inline";
        dropdownInput1.style.display = "none";
        dropdownInput2.style.display = "none";
        dropdownInput3.style.display = "none";
        dropdownRoom.style.display = "none";
        dropdownBed.style.display = "none";
    }
    else if (filter == "Room Number") {
        textInput.style.display = "none";
        dropdownInput.style.display = "none";
        dropdownInput1.style.display = "none";
        dropdownInput2.style.display = "none";
        dropdownInput3.style.display = "none";
        dropdownRoom.style.display = "inline";
        dropdownBed.style.display = "none";
    }
    else if (filter == "Bed Number") {
        textInput.style.display = "none";
        dropdownInput.style.display = "none";
        dropdownInput1.style.display = "none";
        dropdownInput2.style.display = "none";
        dropdownInput3.style.display = "none";
        dropdownRoom.style.display = "none";
        dropdownBed.style.display = "inline";
    }
    else {
        textInput.style.display = "inline";
        dropdownInput.style.display = "none";
        dropdownInput1.style.display = "none";
        dropdownInput2.style.display = "none";
        dropdownInput3.style.display = "none";
        dropdownRoom.style.display = "none";
        dropdownBed.style.display = "none";
    }
}

function updateDays() {
    const dayDropdown = document.getElementById("dropdownInput1");
    const monthDropdown = document.getElementById("dropdownInput2");
    const yearDropdown = document.getElementById("dropdownInput3");

    const selectedMonth = parseInt(monthDropdown.value);
    const selectedYear = parseInt(yearDropdown.value);

    // Calculate days in the selected month and year
    const daysInMonth = new Date(selectedYear, selectedMonth, 0).getDate();

    // Clear the current options in the day dropdown
    dayDropdown.innerHTML = "";

    // Populate the day dropdown with the correct number of days
    for (let day = 1; day <= daysInMonth; day++) {
        const option = document.createElement("option");
        option.value = day;
        option.textContent = day;
        dayDropdown.appendChild(option);
    }
}

// Initialize the days dropdown for the default month/year
document.addEventListener("DOMContentLoaded", () => {
    updateDays();
});

document.addEventListener("DOMContentLoaded", function () {
    // Select all delete icons
    const deleteIcons = document.querySelectorAll(".delete-icon");

    deleteIcons.forEach(icon => {
        icon.addEventListener("click", function () {
            const itemId = this.getAttribute("data-id"); // Get the item ID
            const row = this.closest("tr"); // Get the row to remove
            const confirmed = confirm("Are you sure you want to delete this item?");

            if (confirmed) {
                fetch(`/delete-item/${itemId}`, {
                    method: 'DELETE',
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error("Failed to delete item.");
                    }
                    return response.json();
                })
                .then(data => {
                    alert(data.message);
                    // Remove the row from the DOM
                    row.remove();
                })
                .catch(error => {
                    console.error(error);
                    alert("An error occurred while deleting the item.");
                });
            }
        });
    });
});

(function ($) {
    "use strict";

    // Dropdown on mouse hover
    $(document).ready(function () {
        function toggleNavbarMethod() {
            if ($(window).width() > 992) {
                $('.navbar .dropdown')
                    .on('mouseover', function () {
                        $('.dropdown-toggle', this).trigger('click');
                    })
                    .on('mouseout', function () {
                        $('.dropdown-toggle', this).trigger('click').blur();
                    });
            } else {
                $('.navbar .dropdown').off('mouseover').off('mouseout');
            }
        }
        toggleNavbarMethod();
        $(window).resize(toggleNavbarMethod);
    });

    // Date and time picker
    $('.date').datetimepicker({
        format: 'L',
    });
    $('.time').datetimepicker({
        format: 'LT',
    });
})(jQuery);