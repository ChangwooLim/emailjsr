const feedback_btn = document.querySelector("#report_btn");
const wrapper = document.querySelector(".wrapper");
const close_btns = document.querySelectorAll(".close_btn");
const li_items = document.querySelectorAll("ul li");
const submit_btn = document.querySelector(".submit_btn");
const username = document.querySelector("#name");
const email = document.querySelector("#email");
const message = document.querySelector("#reporttext");
const sendingtext = document.querySelector("#sending");
const senttext = document.querySelector("#sent");
const senderror = document.querySelector("#senderror");

$(function(){
  // Waiting for `{shiny}` to be connected
function sendmail(templateParams){
              sendingtext.classList.remove("invisible");
              senderror.classList.add("invisible");
              senttext.classList.add("invisible");
              emailjs.send(serviceId, templateId, templateParams)
              .then(function(res) {
                console.log(res.status, res.text);
                senttext.classList.remove("invisible");
              }, function(e) {
                console.error(e);
                senderror.classList.remove("invisible");
              }).then(() => {
                sendingtext.classList.add("invisible");
              });
            }
   feedback_btn.addEventListener("click", function () {
	wrapper.classList.add("active");
});

(function(){
            emailjs.init(userId);
          })();

close_btns.forEach(function (btn) {
	btn.addEventListener("click", function () {
		wrapper.classList.remove("active");
	});
});

li_items.forEach(function (item) {
	item.addEventListener("click", function () {
		li_items.forEach(function (item) {
			item.classList.remove("active");
		});

		item.classList.add("active");
	});
});

submit_btn.addEventListener("click", (e) => {
  e.preventDefault();
  const templateParams = {
    fromName: username.value,
    message: message.value,
    replyTo: email.value,
    userAgent: window.navigator.userAgent,
    browserWidth: window.innerWidth,
    browserHeight: window.innerHeight,
  };

  sendmail(templateParams);
});

  $(document).on('shiny:disconnected', function(e) {
    alert("Click");
    feedback_btn.classList.remove("invisible");
  });

});
