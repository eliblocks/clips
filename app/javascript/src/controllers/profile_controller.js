import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  connect() {
    const uploader = cloudinary.createUploadWidget({
      cloudName: 'dvizsamps',
      apiKey: "845485225187822",
      uploadPreset: "ur1v3sps",
      multiple: false,
      clientAllowedFormats: ["png","gif", "jpeg"]
    }, (error, result) => { 
        if (!error && result && result.event === "success") { 
          var id = result.info.public_id;
          document.querySelector("#cloudinary-image").getAttribute("src", result.info.url);
          document.querySelector("#image-field").setAttribute("value", id);
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
