/**
 * Common JavaScript utilities for Electricity Billing System
 */

// Add notification container to page
$(document).ready(function() {
    if (!$('#notification-container').length) {
        $('body').append('<div id="notification-container"></div>');
    }
});

/**
 * Show a success notification
 * @param {string} message
 */
function showSuccess(message) {
    showNotification(message, 'success');
}

/**
 * Show an error notification
 * @param {string} message
 */
function showError(message) {
    showNotification(message, 'danger');
}

/**
 * Show a warning notification
 * @param {string} message
 */
function showWarning(message) {
    showNotification(message, 'warning');
}

/**
 * Show a notification toast
 * @param {string} message
 * @param {string} type  Bootstrap alert type: success, danger, warning, info
 */
function showNotification(message, type) {
    var icons = { success: '&#10003;', danger: '&#10007;', warning: '&#9888;', info: '&#8505;' };
    var icon = icons[type] || '&#8505;';
    var id = 'notif-' + Date.now();
    var html = '<div id="' + id + '" class="alert alert-' + type + ' alert-dismissible fade show" role="alert">'
             + '<strong>' + icon + '</strong> ' + message
             + '<button type="button" class="close" data-dismiss="alert">'
             + '<span>&times;</span></button></div>';
    $('#notification-container').append(html);
    setTimeout(function() {
        $('#' + id).alert('close');
    }, 5000);
}

/**
 * Format a number as USD currency
 * @param {number} amount
 * @returns {string}
 */
function formatUSD(amount) {
    return '$' + parseFloat(amount || 0).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

/**
 * Format a number as LBP currency
 * @param {number} amount
 * @returns {string}
 */
function formatLBP(amount) {
    return parseFloat(amount || 0).toLocaleString() + ' LBP';
}

/**
 * Get the month name from a month number (1-12)
 * @param {number} month
 * @returns {string}
 */
function getMonthName(month) {
    var months = ['January','February','March','April','May','June',
                  'July','August','September','October','November','December'];
    return months[month - 1] || '';
}

/**
 * Add CSRF headers to jQuery AJAX requests globally
 */
$(document).ajaxSend(function(e, xhr, options) {
    var token = $('meta[name="_csrf"]').attr('content');
    var header = $('meta[name="_csrf_header"]').attr('content');
    if (token && header) {
        xhr.setRequestHeader(header, token);
    }
});
