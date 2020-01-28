// $.fn.modal.Constructor.prototype.enforceFocus = function() {
//   modal_this = this
//   $(document).on('focusin.modal', function (e) {
//     if (modal_this.$element[0] !== e.target && !modal_this.$element.has(e.target).length 
//     && !$(e.target.parentNode).hasClass('cke_dialog_ui_input_select') 
//     && !$(e.target.parentNode).hasClass('cke_dialog_ui_input_text')) {
//       modal_this.$element.focus()
//     }
//   })
// };

// CKEDITOR.on('dialogDefinition', function(e) {
//     if (e.data.name === 'link') {
//       var target = e.data.definition.getContents('target');
//       var options = target.get('linkTargetType').items;
//       for (var i = options.length-1; i >= 0; i--) {
//         var label = options[i][0];
//         if (!label.match(/new window/i)) {
//           options.splice(i, 1);
//         }
//       }
//       var targetField = target.get( 'linkTargetType' );
//       targetField['default'] = '_blank';	
//     }	
// });


// CKEDITOR.on( 'dialogDefinition', function( ev ){		
// 	var dialogName = ev.data.name;
// 	var dialogDefinition = ev.data.definition;
// 	if ( dialogName == 'link' || dialogName == 'table' || dialogName == 'tableProperties' || dialogName == 'image'){			
// 		// dialogDefinition.removeContents( 'target' );
// 		dialogDefinition.removeContents( 'advanced' );	
// 	}
// });