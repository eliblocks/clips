import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    const uploader = cloudinary.createUploadWidget({
      cloudName: 'dvizsamps',
      apiKey: "845485225187822",
      uploadPreset: "ur1v3sps",
      multiple: false,
    }, (error, result) => { 
        if (!error && result && result.event === "success") { 
          console.log('Done! Here is the image info: ', result.info);
          var id = result.info.public_id;
          var oldUrl = $("#cloudinary-image").attr("src");
          var newUrl = oldUrl.replace(/\w+$/, id);
          $("#cloudinary-image").attr("src", newUrl);
          $("#image-field").attr("value", id);
          var form = document.querySelector("#profile-pic-form")
          Rails.fire(form, "submit");
        }
      }
    )

    document.getElementById("file-upload").addEventListener("click", function() {
      uploader.open();
    }, false);
  }
}