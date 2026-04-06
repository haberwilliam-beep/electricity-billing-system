/**
 * Electricity Billing System - Main JavaScript
 * Common utilities and helpers for all pages.
 */

// Global context path
var APP_CTX = (function() {
    var scripts = document.getElementsByTagName('script');
    return '';
}());

/**
 * Display a dismissible alert toast.
 * @param {string} type  - Bootstrap color: 'success', 'danger', 'warning', 'info'
 * @param {string} message
 * @param {number} timeout - auto-dismiss ms (default 4000)
 */
function showAlert(type, message, timeout) {
    timeout = timeout || 4000;
    if (!$('#alertContainer').length) {
        $('body').append('<div id="alertContainer"></div>');
    }
    var id = 'alert_' + Date.now();
    var iconMap = {
        success: 'check-circle', danger: 'exclamation-triangle',
        warning: 'exclamation-circle', info: 'info-circle'
    };
    var icon = iconMap[type] || 'info-circle';
    var html = '<div id="' + id + '" class="alert alert-' + type + ' alert-dismissible fade show" role="alert">'
        + '<i class="fas fa-' + icon + ' mr-2"></i>' + message
        + '<button type="button" class="close" data-dismiss="alert">&times;</button>'
        + '</div>';
    $('#alertContainer').append(html);
    setTimeout(function() {
        $('#' + id).alert('close');
    }, timeout);
}

/**
 * Show a loading spinner overlay.
 */
function showLoading() {
    if (!$('#loadingOverlay').length) {
        $('body').append('<div id="loadingOverlay" class="loading-overlay">'
            + '<div class="text-center"><i class="fas fa-spinner fa-spin fa-3x text-primary"></i>'
            + '<p class="mt-2">Loading...</p></div></div>');
    }
    $('#loadingOverlay').show();
}

/**
 * Hide loading overlay.
 */
function hideLoading() {
    $('#loadingOverlay').hide();
}

/**
 * Global AJAX setup - add CSRF header if needed, handle errors.
 */
$(document).ajaxError(function(event, xhr, settings, thrownError) {
    var msg = 'An error occurred.';
    if (xhr.status === 403) msg = 'Access denied.';
    else if (xhr.status === 404) msg = 'Resource not found.';
    else if (xhr.status === 500) msg = 'Server error. Please try again.';
    else if (xhr.responseJSON && xhr.responseJSON.message) msg = xhr.responseJSON.message;
    showAlert('danger', msg);
});

$(document).ajaxStart(function() {
    // Don't show overlay for jqGrid data loads to avoid flicker
});

/**
 * Format a number with commas.
 */
function formatNumber(n, decimals) {
    if (n == null || n === '') return '-';
    decimals = decimals !== undefined ? decimals : 2;
    return parseFloat(n).toLocaleString('en-US', {
        minimumFractionDigits: decimals,
        maximumFractionDigits: decimals
    });
}

/**
 * jqGrid default settings applied globally.
 */
$.extend($.jgrid.defaults, {
    regional: 'en',
    height: 'auto',
    autowidth: true,
    shrinkToFit: true,
    viewrecords: true,
    rowNum: 10,
    rowList: [10, 20, 50, 100],
    pagerpos: 'center',
    recordpos: 'right',
    recordtext: 'Showing {0} - {1} of {2}',
    pgtext: 'Page {0} of {1}',
    emptyrecords: 'No records found',
    loadtext: 'Loading...',
    loadui: 'block'
});

/**
 * Confirm deletion utility.
 */
function confirmDelete(message, callback) {
    if (confirm(message || 'Are you sure you want to delete this record?')) {
        callback();
    }
}

/**
 * Simple form validation - checks required fields.
 * @param {string} formId - jQuery selector
 * @returns {boolean}
 */
function validateForm(formId) {
    var valid = true;
    $(formId + ' [required]').each(function() {
        $(this).removeClass('is-invalid');
        if (!$(this).val() || $(this).val().trim() === '') {
            $(this).addClass('is-invalid');
            valid = false;
        }
    });
    if (!valid) showAlert('warning', 'Please fill in all required fields.');
    return valid;
}

/**
 * Reset form validation state.
 */
function resetFormValidation(formId) {
    $(formId + ' .is-invalid').removeClass('is-invalid');
}

/**
 * Language switch helper.
 */
function switchLanguage(lang) {
    var url = new URL(window.location.href);
    url.searchParams.set('lang', lang);
    window.location.href = url.toString();
}

// Auto-dismiss Bootstrap alerts
$(document).on('click', '[data-dismiss="alert"]', function() {
    $(this).closest('.alert').remove();
});
