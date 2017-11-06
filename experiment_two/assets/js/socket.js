import {Socket} from "phoenix"
export default socket

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let subtopic = $('h2#style-name').data('style-id');

function channel_init() {
	if ($('body').data('page') != "StyleView/show") {
		return; // wrong page
	}

	let chan = socket.channel("updates:" + subtopic, {});
	let submitButtonObject = $("a#submit-button");
	let submitButton = submitButtonObject[0];
	let deleteButtons = $('.delete-button');
	let editButtons = $('.edit-button');

	chan.join(chan)
	  .receive("ok", resp => { console.log('Joined channel ' + subtopic + ' successfully', resp) })
	  .receive("error", resp => { console.log('Unable to join', resp) })

	// receive from channel
	chan.on("message", got_message);
	chan.on("delete", got_delete);
	chan.on("update", got_update);

	// event listener for making a new message
	submitButton.addEventListener("click", send_message(chan, submitButtonObject));

	// event listeners for deleting messages
	Array.from(deleteButtons).forEach(function(element) {
      element.addEventListener('click', delete_message(chan, element.id));
  });

  // event listeners for editing messages
  Array.from(editButtons).forEach(function(element) {
  	element.addEventListener('click', edit_message(chan, '#' + element.id));
  });
}

$(channel_init);

function got_message(msg) {
	if (msg.style_id == subtopic) {
		$('tbody').prepend('<tr><td>' + msg.content
			+ '</td><td><span><a href="#" id="edit-' + msg.id + '"></a></span></td><tr>');
	}
}

function got_delete(msg) {
	if (msg.style_id == subtopic) {
		$('#delete-' + msg.id).parent().parent().parent().remove();
	}
}

function got_update(msg) {
	if (msg.style_id == subtopic) {
		$('#edit-' + msg.id).parent().parent().parent()[0].children[0].firstChild.nodeValue = msg.content;
	}
}

function send_message(chan, button) {
	return function() {
		content = $('#message-content')[0].value;
		if(content && content.length) {
			chan.push("message",
								{content: content,
		     				 style_id: subtopic});
			$('#message_content').val('');
		}
	}
}

function delete_message(chan, id) {
	return function() {
		chan.push("delete", {id: parseInt(id.substring(7)),
		                     style_id: subtopic});
	};
}

function edit_message(chan, id) {
	return function() {
		let rowElement = $(id).parent().parent().parent();
		let childElement = rowElement.children()[0];

		if($(id).text() === "Edit") {
			let input = '<td><input type="text" value="'
			            + childElement.firstChild.nodeValue
			            + '"></td>'
			childElement.remove();
			rowElement.prepend(input);
			$(id).text('Update');
		}
		else {
			let content = childElement.firstChild.value;
			$(id).text('Edit');
			chan.push("update", {id: parseInt(id.substring(6)),
			                     content: content,
			                     style_id: subtopic});

			childElement.remove();
			rowElement.prepend('<td>' + content + '</td>');
		}
	};
}
