<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Resumable.js - Multiple simultaneous, stable and resumable uploads via the HTML5 File API</title>
    <meta charset="utf-8" />
      <link href="../../Contents/style.css" rel="stylesheet" type="text/css" />
      <script src="../../Scripts/resumable-node.js" type="text/javascript"></script>
      <script src="../../Scripts/resumable.js" type="text/javascript"></script>
      <script src="../../Scripts/app.js" type="text/javascript"></script>
      
      
   
  </head>
  <body>
    <div id="frame">

      <hr/>

      <h3>Demo</h3>
   
        <script src="../../Scripts/jquery-1.7.2.min.js"></script>
        <script src="../../Scripts/resumable.js" type="text/javascript"></script>

      <div class="resumable-error">
        Your browser, unfortunately, is not supported by Resumable.js. The library requires support for <a href="http://www.w3.org/TR/FileAPI/">the HTML5 File API</a> along with <a href="http://www.w3.org/TR/FileAPI/#normalization-of-params">file slicing</a>.
      </div>

      <div class="resumable-drop" ondragenter="jQuery(this).addClass('resumable-dragover');" ondragend="jQuery(this).removeClass('resumable-dragover');" ondrop="jQuery(this).removeClass('resumable-dragover');">
        Drop video files here to upload or <a class="resumable-browse"><u>select from your computer</u></a>
      </div>
      
      <div class="resumable-progress">
        <table>
          <tr>
            <td style="width:100%"><div class="progress-container"><div class="progress-bar"></div></div></td>
            <td class="progress-text" nowrap="nowrap"></td>
            <td class="progress-pause" nowrap="nowrap">
              <a href="#" onclick="r.upload(); return(false);" class="progress-resume-link"><img src="../../Contents/resume.png" title="Resume upload" /></a>
              <a href="#" onclick="r.pause(); return(false);" class="progress-pause-link"><img src="../../Contents/pause.png" title="Pause upload" /></a>
            </td>
          </tr>
        </table>
      </div>
      
      <ul class="resumable-list"></ul>

      <script>
          var r = new Resumable({
              target: '/Home/UploadFiles',
              chunkSize: 1 * 1024 * 1024,
              simultaneousUploads: 4,
              testChunks: true,
              throttleProgressCallbacks: 1
          });
          // Resumable.js isn't supported, fall back on a different method
          if (!r.support) {
              $('.resumable-error').show();
          } else {
              // Show a place for dropping/selecting files
              $('.resumable-drop').show();
              r.assignDrop($('.resumable-drop')[0]);
              r.assignBrowse($('.resumable-browse')[0]);

              // Handle file add event
              r.on('fileAdded', function (file) {
                  // Show progress pabr
                  $('.resumable-progress, .resumable-list').show();
                  // Show pause, hide resume
                  $('.resumable-progress .progress-resume-link').hide();
                  $('.resumable-progress .progress-pause-link').show();
                  // Add the file to the list
                  $('.resumable-list').append('<li class="resumable-file-' + file.uniqueIdentifier + '">Uploading <span class="resumable-file-name"></span> <span class="resumable-file-progress"></span>');
                  $('.resumable-file-' + file.uniqueIdentifier + ' .resumable-file-name').html(file.fileName);
                  // Actually start the upload
                  r.upload();
              });
              r.on('pause', function () {
                  // Show resume, hide pause
                  $('.resumable-progress .progress-resume-link').show();
                  $('.resumable-progress .progress-pause-link').hide();
              });
              r.on('complete', function () {
                  // Hide pause/resume when the upload has completed
                  $('.resumable-progress .progress-resume-link, .resumable-progress .progress-pause-link').hide();
              });
              r.on('fileSuccess', function (file, message) {
                  // Reflect that the file upload has completed
                  $('.resumable-file-' + file.uniqueIdentifier + ' .resumable-file-progress').html('(completed)');
              });
              r.on('fileError', function (file, message) {
                  // Reflect that the file upload has resulted in error
                  $('.resumable-file-' + file.uniqueIdentifier + ' .resumable-file-progress').html('(file could not be uploaded: ' + message + ')');
              });
              r.on('fileProgress', function (file) {
                  // Handle progress for both the file and the overall upload
                  $('.resumable-file-' + file.uniqueIdentifier + ' .resumable-file-progress').html(Math.floor(file.progress() * 100) + '%');
                  $('.progress-bar').css({ width: Math.floor(r.progress() * 100) + '%' });
              });
          }
      </script>

    </div>
  </body>
</html>


    
