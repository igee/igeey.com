/**
 *  IG.dialog for igeey.com
 *  Based on Lee dilaog 1.0 http://www.xij.cn/blog/?p=68
 */

(function($) {
  var $w = $(window), $d = $(document),
    IE6 = !window.XMLHttpRequest,
    toInt = function(num) { return parseInt(num, 10) };

  function Dialog() {
    this.tmpl = [
      '<div id="{{name}}" class="{{name}}">',
        '<div class="dialog_title">',
          '<h4>{{title}}</h4><span title="关闭" id="close_dialog"">关闭</span>',
        '</div>',
        '<div class="dialog_content">{{content}}</div>',
      '</div>',
      '<div id="{{name}}Bg"></div>'
    ].join('');
    
    this.settings = {
      name: 'floatBox',
      title: 'title',
      content: '<p>empty yet.</p>',
      url: '',
      iframe: false,
      width: '300px',
      top: '80px',
      data: '',
      heigth: ''
    };
  };
  
  Dialog.prototype = {
    init: function(o) {
      var opts = this.opts = $.extend({}, this.settings, o || {}),
        $tmpl = $(substitute(this.tmpl, opts));
      
      if ( this.ready ) {
        this.$tmpl.replaceWith( $tmpl );
      } else {
        $tmpl.appendTo('body').hide();
      }
      
      this.$tmpl = $tmpl;
      this.$dialog = $tmpl.eq(0);
      this.$overlay = $tmpl.eq(1).bind( 'click', $.proxy(this.close, this) );
      this.$close = $tmpl.find('#close_dialog').bind( 'click', $.proxy(this.close, this) );      
      this.$content = $tmpl.find('.dialog_content');
      
      this.ready = true;
      return opts.url ? this.loadContent() : this.show();
    },
    
    loadContent: function() {
      if ( this.opts.iframe ) {
        //TODO: insert an iframe
      } else {
        $.ajax({
          url: this.opts.url,
          data: this.opts.data,
          beforeSend: $.proxy(this.handleAjax('waiting'),this),
          error: $.proxy(this.handleAjax('error'),this),
          success: $.proxy(this.handleAjax('success'),this)
        });
      }
      return this.show();
    },
    
    handleAjax: function( type ){
      return function( received ){
        this.$content.html({
          waiting: this.opts.spinner || 'loading..',
          error: this.opts.error || 'ooops',
          success: received
        }[type]);
      };
    },
      
    show: function() {
      var opts = this.opts;
      this.$overlay.height($d.height()).show();
      
      this.$dialog
        .css({width: opts.width, height:opts.height, position: IE6 ? 'absolute' : 'fixed'})
        .show().animate({top: (IE6 ? $d.scrollTop() + toInt(opts.top) : opts.top)}, 'fast');
      
      return this.bindEvent();
    },
    
    bindEvent: function() {
      $w.resize( $.proxy(function(){
        this.$dialog.css('left', ($d.width() - toInt(this.opts.width)) / 2 + 'px');
      }, this)).resize();
      
      IE6 && $w.scroll($.proxy(function() {
        this.$dialog.css('top', $d.scrollTop() + toInt(this.opts.top));
      }, this));
            
      $d.keyup($.proxy(function(e) {
        if (e.keyCode == 27) this.close();
      }, this));
      
      return this;
    },

    close: function() {
      this.$dialog.animate({ top:'-500px' }, "normal", function(){
         $(this).remove();
      });
      this.$overlay.fadeOut('fast',function(){
        $(this).remove()
      });
      this.ready = false;
      
      return this;
    }
  };
  
  /**
   * Inspired by Dojo.string.substitute
   */
  function substitute(tmpl, hash) {
    for (var name in hash) {
      if (hash.hasOwnProperty(name)) {
        tmpl = tmpl.replace(RegExp("{{+" + name + "+}}", "g"), hash[name]);
      }
    }
    return tmpl;
  }

  /**
   *  Defining interfaces
   */
  window.IG || ( window.IG = {} );
  
  window.IG.dialog = {
    defaults: {
      top:'80px',
      width:'570px',
      data:'layout=false',
      spinner: '读取中..请稍后',
      error: 'error..'
    },
    init: (function(dialog) {
      return function(o) {
        return dialog.init( $.extend(this.defaults, o) );
      };
    }(new Dialog))
  };
  
}(jQuery));
