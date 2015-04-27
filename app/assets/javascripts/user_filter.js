window.userFilter = function() {  
  return { 
    init: function() {
      roleFilter();
      showInactive();
    }
  }
  function roleFilter () {
    $('select#role').change(function () {
      var role = $('select#role').val();
      if (role.length) {
        $('h1').text("Users - " + ($('select#role option:selected').text()));
        $("tr.user-row").hide();
        $("tr.role-" + role).show();
      } else {
        $('h1').text('Users');
        $("tr.user-row").show();
      }
    });
  }
  function showInactive() {
    $('#show_inactive').change(function () {
      var checked = this.checked;
      var location = window.location.search;
      var href = window.location.href;

      if (location == "")  {
        window.location.href = href + "?show_inactive=true";
        return;
      }
      if (location.indexOf('show_inactive') == -1) {
        window.location.href = href + "&show_inactive=true";
        return;
      }
      window.location.href = href.replace(/true|false/gi, checked);

    });
  }

}