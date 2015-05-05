document.addEventListener('DOMContentLoaded', function(event) {
  var exit = document.getElementById('exit-modal');
  var thumb = document.getElementById('l-thumb');
  var modal = document.getElementById('modal');

  exit.addEventListener('click', function(event) {
    modal.className = 'hidden';
    fingerprint.scanFinger('Dutch', 'M', 'Left Thumb', function(res) {
      console.log(res);
    });
  });

  thumb.addEventListener('click', function(event) {
    modal.className = '';
  });
});
