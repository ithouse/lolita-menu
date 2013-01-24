$(document).ready(function(){
  function save_menu_tree(tree){
    var new_positions = tree.nestedSortable('toArray');

    if(tree.data("old_positions")!=tree.nestedSortable('serialize')){
      $.ajax({
        url:tree.attr("data-url"),
        type:"put",
        dataType:"html",
        data:$.param({items:new_positions}),
        success:function(){
          tree.data("old_positions",tree.nestedSortable('serialize'))
        }
      })
    }
  }

  $("ol.nested-tree-items-tree").nestedSortable({
    disableNesting: 'no-nest',
    forcePlaceholderSize: true,
    handle: 'div',
    helper: 'clone',
    items: 'li',
    maxLevels: 5,
    opacity: .6,
    placeholder: 'placeholder',
    revert: 250,
    tabSize: 25,
    tolerance: 'pointer',
    toleranceElement: '> div',
    stop:function(branch,args){
      save_menu_tree($(this));
    }
  })

  $("ol.nested-tree-items-tree").each(function(){
    $(this).data("old_positions",$(this).nestedSortable("serialize"))
  })

  $(".openable-row").click(function(event){
    var that=this
    $(".subrow").hide(0)
    $("#branch_"+$(this).attr("data-id")).show(0);

    //event.preventDefault();
  })

  $(".add_new_nested_tree_item").click(function(){
    $.ajax({
      url:$(this).attr("data-url"),
      type:"post",
      context: $("#nested_tree_"+$(this).attr("data-id")),
      dataType:"html",
      success:function(html_data){
        $(this).append(html_data)
      }
    })
  })

  $(document).on("click",".delete-nested-tree-item",function(){
    var self = this;
    $.ajax({
      url:$(this).attr("data-url"),
      type:"delete",
      dataType: "json",
      success:function(data){
        $($(self).attr("data-row")).remove();
        save_menu_tree($($(self).attr("data-scope")));
      }
    })
  })

  $(document).on("focus",".nested-tree-content input",function(){
    $(this).data("value",$(this).val())
  })

  $(document).on("blur",".nested-tree-content input",function(){
    var input=$(this);
    if(input.data("value")!=input.val()){
      var match = input.attr("name").match(/\[(\w+)\]$/);
      input.data("value",input.val())
      $.ajax({
        url: input.closest("form").attr("action"),
        type:"put",
        context:$(this),
        dataType:"json",
        data:{attribute: match[1], value: input.val()},
        success:function(data){
          var color=(data.status=="error" ? "#ff5656" : "#aaff56");
          $(this).css("backgroundColor",color);
          $(this).animate({ backgroundColor: "white" }, 1000);
        }
      })
    }
  })
})
