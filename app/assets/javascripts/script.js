// window.jsFunctions = {
//   initializeChoices: function () {
//     const controls = document.querySelectorAll('select');
//     new Choices(controls, {
//       searchEnabled: false,
//       shouldSort: false
//     });
//   }
// }
var data = "";
$(function(){
  if ($("#messages").length > 0) {
    setTimeout(function() {
      get_messages($("#messages").data("conversation-id"));
    }, 2000);
    $("#messages").on("scroll", function() {
      if (preventRefire) return;
      if ($("#messages").scrollTop() == 0) {
        preventRefire = true;
        get_messages($("#messages").data("conversation-id"), $("#messages li").first().data('chat-id'));
      }
    });
    $(".message-input").click(function() {
      $(".conversation-error").hide();
    });
    $("#send_file_holder").click(function() {
      $(".conversation-error").hide();
      $("#send_file").trigger("click");
    })

    // $("#s3-uploader").S3Uploader({
    //   progress_bar_target: $('#property_images_progress_bar .js-progress-bars'),
    //   allow_multiple_files: false,
    //   before_add: function(file) {
    //     return validate_attachement(file, ["jpg", "jpeg", "gif", "png"])
    //   },
    //   remove_completed_progress_bar: false
    // });
    // $('#s3-uploader').bind('s3_uploads_start', function(e) {
    //   // disable_upload_fields();
    //   $("#property_images_progress_bar").show();
    //   $("#property_images_progress_bar .progress .bar").css("width","0");
    // });

    // $('#s3-uploader').bind('s3_upload_complete', function(e) {
    //   // enable_upload_fields();
    //   $("#property_images_progress_bar").hide();
    //   $("#property_images_progress_bar .progress .bar").css("width","0");
    // });
  }

  $('#user_country').change(function () {
    var input_state = $(this);
    var states = [];
    $.getJSON('/state/' + $(this).val(), function (data) {
      $.each(data, function (key,value) {
        var opt = '<option value='+ key +'>' + value + '</option>';
        states.push(opt)
      });
      $('#user_state').html(states);
    });
  });

  // $('#user_date_of_birth_3i').removeClass('date');
  // $('#user_date_of_birth_1i').removeClass('date');
  // $('#user_date_of_birth_2i').removeClass('date');

  // $('#alert-notice').fadeOut( 10000, function() {
  //   $('#alert-notice').remove()
  // });
  // jQuery.extend(jQuery.validator.messages, {
  //   required:"can't be blank"
  // });
  // jQuery.validator.setDefaults({
  //   errorPlacement: function(error, element) {
  //     if (element.attr("name")== "user[image]") {
  //       $("#image-preview").addClass("has-error")
  //       error.appendTo("#image_error");
  //     }else if(element.attr("name") == "user[term_and_condition]") {
  //       $('.user_term_and_condition').addClass('has-error')
  //       error.appendTo('#term_id');
  //     }else if(element.attr("name") == "user[adult]") {
  //       $('.user_adult').addClass('has-error')
  //       error.appendTo('#adult_id');
  //     }else{
  //       error.insertAfter(element);
  //     }
  //   }
  // });
  
  // $('#user_term_and_condition').on('change', function() { 
  //   if (this.checked) {
  //     $('.user_term_and_condition').removeClass('has-error')
  //   }
  // });

  // $('#user_adult').on('change', function() { 
  //     if (this.checked) {
  //       $('.user_adult').removeClass('has-error')
  //     }
  // });

  // $("#s3-uploader-user-image").S3Uploader({
  //   progress_bar_target: $('#user_image_progress_bar .js-progress-bars'),
  //   allow_multiple_files: false,
  //   before_add: function(file) {
  //     return validate_attachement(file, ["jpg", "jpeg", "gif", "png"])
  //   },
  //   remove_completed_progress_bar: false
  // });
  // $('#s3-uploader-user-image').bind('s3_uploads_start', function(e) {
  //     // disable_upload_fields();
  //     $("#user_image_progress_bar").show();
  //     $("#user_image_progress_bar .progress .bar").css("width","0");
  // });
  // $('#s3-uploader-user-image').bind('s3_upload_complete', function(e) {
  //     // enable_upload_fields();
  //     $("#user_image_progress_bar").hide();
  //     $("#user_image_progress_bar .progress .bar").css("width","0");
  // });
  $('#alert-notice').fadeOut( 5000, function() {
    $('#alert-notice').remove()
  });
});

$(function() {
  $(window).bind('rails:flash', function(e, params) {
    new PNotify({
      title: params.type,
      text: params.message,
      type: params.type
    });
  });
});

var preventRefire = false;
function get_messages(conversation_id,chat_id) {
  if($('#offer').length){
    var custom = 'offered'; 
  }else{
    var custom = 'notoffered';
  }
  $.ajax({
    url: "/conversations/" + conversation_id + "/chats",
    data: {conversation_id: conversation_id, chat_id: chat_id, custom: custom},
    success: function (messages) {
      // alert("here");
      if (messages.length > 0) {
        $('.conversation-holder').show();
        $('.vid-rating').hide();
        preventRefire = false;
        // var chat_ids = [];
        for (i=0; i<messages.length; i++) {
          // chat_ids.push(messages[i]['id']);
          $("#messages").prepend(show_message(messages[i]));
        }
        // chat_ids.join(",");
        // console.log('conversation_id', conversation_id, current_user_id, chat_ids);
        // setTimeout(function() {
        //   App.global_conversation.update_read(conversation_id, current_user_id, chat_ids);
        // }, 1000);
      }else{
        if(chat_id == null){
          $('.conversation-holder').hide();
          $('.vid-rating').show();
        }
      }
      if (!chat_id) {
        messages_to_bottom();
      }
    }
  })
}

function show_messages(messages) {
  if (messages.length > 0) {
    preventRefire = false;
  }
  $.tmpl("messageTemplate", messages).prependTo("#messages");
  if (messages_page == 1) {
    messages_to_bottom();
  }
  messages_page++;
}

function show_message(message) {
  // console.log(message);
  if(message['custom_offer'] == "1" && message['package_id'] != null){
    if(current_user_role == "seller" && message['sender'] == "by_buyer"){
      message['message'] = message['message_for_seller']
    }
    if(current_user_role == "buyer" && message['sender'] == "by_buyer"){
      message['message'] = message['message_for_buyer']
    }

    if(current_user_role == "seller" && message['sender'] == "by_seller"){
      message['message'] = message['message_for_seller']
    }
    if(current_user_role == "buyer" && message['sender'] == "by_seller"){
      message['message'] = message['message_for_buyer']
    }
  }
  $('.conversation-holder').show();
  $('.vid-rating').hide();
  var url = message['message'].split("<<image>>");
  if (url.length == 1) {
    message_body = message['message'];
  } else {
    var arr = ["pdf","doc","docx"]
    var extension = url[1].split(".").pop()
    if(jQuery.inArray(extension,arr) !== -1){
      message_body = url[0] + '<br><a target="_blank" href="' + url[1] + '"><img class= "thumb" src="https://img.icons8.com/cute-clipart/128/000000/image-file.png" data-src="' + url[1]  + '" /></a>';
    }else{
      message_body = url[0] + '<br><a target="_blank" href="' + url[1] + '"><img class= "thumb" src="' + url[1]  + '" /></a>';
    }
  }
  var message_date = new Date(message['created_at']);
  var html = "";  
  if(message.user_id == current_user_id){
    html = '<div class="incoming_msg">';
    html += '<div class="incoming_msg_img">';
    html += '<img src="' + chats_recipients[message['user_id']]['image'] + '" class="profile-img"><span id="s_name">Me </span><span class="">' + message_date.toLocaleString() + '</span></div>';
    html += '<div class="received_msg">';
    html += '<div class="received_withd_msg">';
    html += '<p>' + message_body + '</p>';
    html += '</div>';
    html += '</div>';
  }else{
    html = '<div class="incoming_msg">';
    html += '<div class="incoming_msg_img">';
    html += '<img src="' + chats_recipients[message['user_id']]['image'] + '" class="profile-img"><span id="s_name">' + user_name  + '</span><span class="">' + message_date.toLocaleString() + '</span></div>';
    html += '<div class="received_msg">';
    html += '<div class="received_withd_msg">';
    html += '<p>' + message_body + '</p>';
    html += '</div>';
    html += '</div>';
  }
  return html;
}

messages_to_bottom = function() {
  return $("#messages").scrollTop($("#messages").prop("scrollHeight"));
};

function validate_attachement(file, allowed_extentions){
  ext = file.name.split('.').pop().toLowerCase();
  if ($.inArray(ext, allowed_extentions) != -1) {
    if (file.size > 2000000) {
      $(".conversation-error").html("The maximum image upload size is 2MB. Please upload a smaller image file.").show();
      // alert('The maximum image upload size is 2MB. Please upload a smaller image file.');
      return false;
    }
    return true;
  } else {
    $(".conversation-error").html("Allowed extensions are " + allowed_extentions.join(", ")).show();
    // alert("Allowed extensions are " + allowed_extentions.join(", "));
    return false;
  }
}

function show_notification(message) {
  console.log(message);
  if (message.notification_counter == 0) {
    $(".req .notify").remove();
  } else {
    if ($('.notify').length == 1) {
      $('.notify').html(message.notification_counter)
    } else {
      var html = "";
      html += "<span class='notify'>";
      html += message.notification_counter;
      html += "</span>";
      $('.req').html(html)
    }
  }
}


function show_notification_visitor(message) {
  new PNotify({
      title: 'Notification',
      text: message.visitor_notification
  });
}

// function GetTodayDate() {
//    var tdate = new Date();
//    var dd = tdate.getDate(); 
//    var MM = tdate.getMonth(); 
//    var yyyy = tdate.getFullYear(); 
//    var hours = tdate.getHours();  
//    var min   =  tdate.getMinutes(); 
//    var sec  =  tdate.getSeconds();
//    var xxx = dd + "-" +( MM+1) + "-" + yyyy + " " + hours + ":" + min + ":" + sec ;
//    return xxx;
// }

var session;
function set_video(apiKey,sessionId,token){
  // Enable console logs for debugging
  TB.setLogLevel(TB.DEBUG);
  // Initialize session, set up event listeners, and connect
  session = OT.initSession(apiKey, sessionId);
  session.connect(token, function(error){
    if(error){
      end(sessionId);
      console.log( error );
      console.log(session.connection.creationTime)
    }else{
      // Create publisher and start streaming into the session  
      var publisher = OT.initPublisher('myPublisherDiv',{insertMode: 'append',maxResolution: '1920*1920',width: 0,height: 0,facingMode: "user"});
      session.publish(publisher);
      $(".endcall").hide();
      var session_timestamp = session.connection.creationTime
      var myVar = setInterval(timer, 1000)
      // navigator.mediaDevices.getUserMedia({video: {facingMode: "user"}});
      console.log(myVar + "session")
    }
  });
  session.on({ 
    streamCreated: function(event){
      session.subscribe(event.stream,"videos",{width: '100%', height: 550 ,insertMode: 'append',facingMode: "user"}); 
      // navigator.mediaDevices.getUserMedia({video: {facingMode: "user"}});
      $('#myPublisherDiv').hide(); 
      $(".endcall").show();
      $('.wait').hide();
    } 
  });
}

function comment_message_show(message){
  $.ajax({
    url:  "/reviews/" + message.order_item_id,
    type: "get",
    dataType: 'script',
    success: function(response){
      // document.getElementById("new_review").reset();
    },
  })
}
function tip_message_show_for_member(message){
 console.log(message)
  new PNotify({
    title: 'Success!',
    text: 'Your tip has successfully given.'
  }); 
}

// $(document).ready(function() {
//   $.uploadPreview({
//     input_field: "#image-upload",
//     preview_box: "#image-preview",
//     label_field: "#image-label"
//   });
// });
function myFunction() {
  document.getElementById("myDropdown").classList.toggle("show");
}

$(document).on('hidden.bs.modal', '#videoModal', function (event) {
  var id = $("#accept").attr("value");
  if(id != "" || id != null){
    end(id,"end")
  }
});

$(function(){
  var hash = window.location.hash;
  hash && $('ul.nav a[href="' + hash + '"]').tab('show');

  $('.nav-tabs a').click(function (e) {
    $(this).tab('show');
    var scrollmem = $('body').scrollTop();
    window.location.hash = this.hash;
    $('html,body').scrollTop(scrollmem);
  });
});
// $(function(){
  
// });