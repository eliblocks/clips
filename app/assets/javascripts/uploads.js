// Using uppy now
// $(document).on("turbolinks:load", function() {
//   var signature = 0002066747970;
//   var signature1 = '000';
//   var signature2 = '66747970';
//   $(".video-upload").fileupload({
//     sequentialUploads: true,

//     add: function(e, data) {
//       console.log("add", data);


//       getFileDuration(data);

//       data.progressBar = buildFileRow(data);

//       console.log(data.progressBar);

//       var options      = {
//         extension: data.files[0].name.match(/(\.\w+)?$/)[0], // set the file extension
//         _: Date.now() // prevent caching
//       };

//       getFileHex(data, options, logResult);
//     },

//     progress: function(e, data) {
//       // console.log("progress", data);
//       var progress   = parseInt(data.loaded / data.total * 100, 10);
//       var percentage = progress.toString() + '%';
//       data.progressBar.find(".progress-bar").css("width", percentage).html(percentage);
//     },

//     done: function(e, data) {

//       console.log("done", data);
//       $("#continue").show(); 
 
//       var clip = {
//         id:       data.formData.key, // we have to remove the prefix part
//         storage:  'cache',
//         metadata: {
//           size:      data.files[0].size,
//           filename:  data.files[0].name.match(/[^\/\\]+$/)[0], // IE return full path
//           mime_type: data.files[0].type,
//           duration:  data.files[0].duration
//         }
//       };

//       var form = $(this).closest("form");
   
//       var formData = new FormData(form[0]);
//       formData.append($(this).attr("name"), JSON.stringify(clip));
//       formData.append("video[title]", clip.metadata.filename);
//       console.log(clip.metadata.filename);
      
//       $.ajax(form.attr("action"), {
//         contentType: false,
//         processData: false,
//         data:        formData,
//         method:      form.attr("method"),
//         dataType:    "json",
//         success: function(response) {
//           console.log("response", response);
//         }
//       });
//     }
//   });

//   function submitFile(data, options) {
//     $.getJSON("/clips/presign", options, function(result) {
//       console.log("presign", result);
//       data.formData  = result.fields;
//       data.url       = result.url;
//       data.paramName = "file";
//       data.submit();
//     });
//   }

//   function buildFileRow(data) {
//     var fileName = data.files[0].name;
//     var listItem = $('<li class="list-group-item"></li>');
//     listItem.html(fileName);
//     var bar = $('<div class="progress" style="width: 300px"><div class="progress-bar"></div></div>');
//     listItem.append(bar);
//     $("#videos").append(listItem);
//     return bar;
//   }

//   function getFileDuration(data) {
//     var video = document.createElement('video');
//     video.preload = 'metadata';
//     video.onloadedmetadata = function() {
//       // window.URL.revokeObjectURL(this.src) - causing 404, omitting might cause issues.
//       data.files[0].duration = video.duration;

//     }
//     video.src = URL.createObjectURL(data.files[0]);
//   }

//   function logResult(data, options, hex) {
//     if (hex.slice(0,3) === signature1 && hex.slice(5,13) === signature2) {
//       submitFile(data, options);
//     } else {
//       displayFileTypeError(data);
//     }
//   }

//   function getFileHex(data, options, callback) {
    
//     var file = data.files[0];
//     var blob = file.slice(0, 8);
//     var filereader = new FileReader()
//     filereader.readAsArrayBuffer(blob);

//     filereader.onloadend = function(e) {
//       var uint = new Uint8Array(e.target.result);
//       var bytes = [];
//       uint.forEach(function(byte) {
//           bytes.push(byte.toString(16));
//       })
//       hex = bytes.join('').toUpperCase();
//       callback(data, options, hex);
//     }
//   }

//   function displayFileTypeError(data) {
//     data.progressBar.parent().addClass("list-group-item-danger");
//     $(".file_type_alert").html("Only mp4 is allowed");
//     $(".file_type_alert").addClass("alert alert-danger");
//   }

// });