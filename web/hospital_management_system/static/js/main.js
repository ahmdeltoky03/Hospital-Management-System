function updateInputField() {
    const filter = document.getElementById("filter").value; // Get the selected filter
    const textInput = document.getElementById("textInput"); // Text input element
    const dropdownInput = document.getElementById("dropdownInput"); // Dropdown input element

    // Toggle visibility based on the selected filter
    if (filter === "isWorking") {
        textInput.style.display = "none";
        dropdownInput.style.display = "inline";
    }
    else if (filter == "getAll") {
        textInput.style.display = "none";
    }
    else {
        textInput.style.display = "inline";
        dropdownInput.style.display = "none";
    }
}

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