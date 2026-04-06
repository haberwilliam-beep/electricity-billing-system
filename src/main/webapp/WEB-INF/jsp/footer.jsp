</div><!-- /container-fluid -->

<!-- Footer -->
<footer class="footer mt-4 py-3 bg-light">
    <div class="container-fluid text-center text-muted">
        <small>Electricity Generator Billing System &copy; 2024</small>
    </div>
</footer>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
        crossorigin="anonymous"></script>
<!-- jQuery UI -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"
        integrity="sha512-uto9mlQzrs59VwILcLiRYeLKPPbS/bT71da/OEBYEwcdNUk8jYIy+D176RYoop1Da+f9mvkYrmj5MCLZWEtQuA=="
        crossorigin="anonymous"></script>
<!-- Bootstrap JS -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"
        integrity="sha384-LtrjvnR4Twt/qOuYxE721u19sVFLVSA4hf/rRt6PrZTmiPltdZcI7q7PXQBYTKyf"
        crossorigin="anonymous"></script>
<!-- jqGrid -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/js/jquery.jqgrid.min.js"
        crossorigin="anonymous"></script>
<!-- Common App JS -->
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
<script>
// Set CSRF token header for all AJAX requests (Spring Security cookie-based CSRF)
$(document).ready(function() {
    function getCookie(name) {
        var match = document.cookie.match(new RegExp('(^|;\\s*)' + name + '=([^;]*)'));
        return match ? decodeURIComponent(match[2]) : null;
    }
    var token = getCookie('XSRF-TOKEN');
    if (token) {
        $.ajaxSetup({ headers: { 'X-XSRF-TOKEN': token } });
    }
});
</script>
</body>
</html>
