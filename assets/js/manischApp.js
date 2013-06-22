// Generated by CoffeeScript 1.6.1
(function() {
  var App, AppView, Item, ItemView, List, ListView, pxwrkHelpersForViews,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  pxwrkHelpersForViews = (function(_super) {

    __extends(pxwrkHelpersForViews, _super);

    function pxwrkHelpersForViews() {
      return pxwrkHelpersForViews.__super__.constructor.apply(this, arguments);
    }

    pxwrkHelpersForViews.prototype.functionLog = function(name) {
      return console.log(name);
    };

    pxwrkHelpersForViews.prototype.valueHasChanged = (function() {
      var latestValue;
      latestValue = [];
      return function(value, id) {
        var result;
        if (value === latestValue[id]) {
          result = false;
        } else {
          latestValue[id] = value;
          result = true;
        }
        return result;
      };
    })();

    return pxwrkHelpersForViews;

  })(Backbone.View);

  /* --------------------------------------------
       Begin item.coffee
  --------------------------------------------
  */


  Item = (function(_super) {

    __extends(Item, _super);

    function Item() {
      return Item.__super__.constructor.apply(this, arguments);
    }

    Item.prototype.defaults = {
      manisch: 'übersetzung fehlt',
      german: 'übersetzung fehlt'
    };

    return Item;

  })(Backbone.Model);

  /* --------------------------------------------
       Begin itemView.coffee
  --------------------------------------------
  */


  ItemView = (function(_super) {

    __extends(ItemView, _super);

    function ItemView() {
      return ItemView.__super__.constructor.apply(this, arguments);
    }

    ItemView.prototype.tagName = 'li';

    ItemView.prototype.initialize = function() {
      return _.bindAll(this);
    };

    ItemView.prototype.render = function(tmpl) {
      if (tmpl) {
        jQuery(this.el).html(_.template(tmpl, this.model.toJSON()));
      } else {
        jQuery(this.el).html('Error: Missing Template');
      }
      return this;
    };

    ItemView.prototype.unrender = function() {
      return $(this.el).remove();
    };

    return ItemView;

  })(pxwrkHelpersForViews);

  /* --------------------------------------------
       Begin List.coffee
  --------------------------------------------
  */


  List = (function(_super) {

    __extends(List, _super);

    function List() {
      return List.__super__.constructor.apply(this, arguments);
    }

    List.prototype.model = Item;

    List.prototype.byCategory = function(categoryName) {
      var result,
        _this = this;
      if (categoryName === 'all') {
        return this;
      } else {
        result = new List;
        _.each(this.models, function(item) {
          var currentItem;
          currentItem = item;
          return _.each(item.get('category'), function(categorie) {
            if (categorie === categoryName) {
              return result.add(currentItem);
            }
          });
        });
        return result;
      }
    };

    List.prototype.search = function(searchParam) {
      var byInput, filtered,
        _this = this;
      if (!searchParam) {
        return this;
      }
      byInput = function(element, index, array) {
        var attributes, pattern;
        attributes = element.toJSON();
        pattern = RegExp(searchParam.toLowerCase());
        return attributes.german.toLowerCase().match(pattern) || attributes.manisch.toLowerCase().match(pattern);
      };
      filtered = new List(this.filter(byInput));
      return filtered;
    };

    return List;

  })(Backbone.Collection);

  /* --------------------------------------------
       Begin ListView.coffee
  --------------------------------------------
  */


  ListView = (function(_super) {

    __extends(ListView, _super);

    function ListView() {
      return ListView.__super__.constructor.apply(this, arguments);
    }

    ListView.prototype.el = '#list';

    ListView.prototype.allTranslations = new List;

    ListView.prototype.requestedTranslations = new List;

    ListView.prototype.getItemsBySearch = function(searchParam) {
      if (searchParam == null) {
        searchParam = false;
      }
      this.functionLog('getItemsBySearch(' + searchParam + ')');
      this.removeAllItems();
      return this.requestedTranslations.search(searchParam);
    };

    ListView.prototype.getItemsByCategory = function(categoryName) {
      this.functionLog('getItemsByCategory()');
      jQuery('.sort.active').removeClass('active');
      jQuery('#' + categoryName).addClass('active');
      this.removeAllItems();
      return this.requestedTranslations = this.allTranslations.byCategory(categoryName);
    };

    ListView.prototype.appendItem = function(item) {
      var itemView;
      this.functionLog('appendItem()');
      itemView = new ItemView({
        model: item,
        tmpl: this.itemTmpl
      });
      return $(this.el).append(itemView.render(this.itemTmpl).el);
    };

    ListView.prototype.getClassName = (function() {
      var itemsCounter, latestTranslation, translationsCounter;
      latestTranslation = false;
      translationsCounter = 0;
      itemsCounter = 0;
      return function(item, collection) {
        var result;
        if (latestTranslation.german === item.toJSON().german) {
          result = 'same-german';
        } else if (latestTranslation.manisch === item.toJSON().manisch) {
          result = 'same-manisch';
        } else {
          result = '';
          translationsCounter++;
        }
        if (translationsCounter % 2 === 0) {
          result += ' even';
        } else {
          result += ' odd';
        }
        itemsCounter++;
        if (itemsCounter === collection.length) {
          translationsCounter = 0;
          itemsCounter = 0;
          latestTranslation = false;
        } else {
          latestTranslation = item.toJSON();
        }
        return result;
      };
    })();

    ListView.prototype.appendItems = function(collection) {
      var html,
        _this = this;
      console.log('collection: ' + collection);
      html = '';
      _.each(collection.models, function(item) {
        var itemView;
        item.set('currentlyVisible', true);
        itemView = new ItemView({
          model: item,
          className: _this.getClassName(item, collection)
        });
        return html += itemView.render(_this.itemTmpl).el.outerHTML;
      });
      return jQuery(this.el).append(html);
    };

    ListView.prototype.removeAllItems = function() {
      _.each(this.allTranslations.models, function(item) {
        return item.set('currentlyVisible', false);
      });
      return jQuery(this.el).html('');
    };

    ListView.prototype.itemTmpl = (function() {
      var t,
        _this = this;
      t = false;
      return (function() {
        if (t === false) {
          jQuery.ajax({
            url: 'site/templates/item.html',
            async: false,
            dataType: 'html',
            success: function(data) {
              return t = data;
            },
            error: function() {
              return this.functionLog('error');
            }
          });
        }
        return t;
      })();
    })();

    ListView.prototype.initialize = function() {};

    ListView.prototype.render = function() {
      return this.functionLog('render()');
    };

    return ListView;

  })(pxwrkHelpersForViews);

  /* --------------------------------------------
       Begin manischApp.coffee
  --------------------------------------------
  */


  AppView = (function(_super) {

    __extends(AppView, _super);

    function AppView() {
      return AppView.__super__.constructor.apply(this, arguments);
    }

    AppView.prototype.list = new ListView;

    AppView.prototype.setFocusToFirstInput = function() {
      return jQuery('input:visible:first:text').focus();
    };

    AppView.prototype.searchTimeout = false;

    AppView.prototype.stopSearch = function() {
      return clearTimeout(this.searchTimeout);
    };

    AppView.prototype.performScrollCheck = function() {
      if (jQuery('body').hasClass('fixsearch')) {
        if (jQuery(window).scrollTop() < this.navHeight) {
          return jQuery('body').removeClass('fixsearch');
        }
      } else {
        if (jQuery(window).scrollTop() > this.navHeight) {
          return jQuery('body').addClass('fixsearch');
        }
      }
    };

    AppView.prototype.events = {
      'click .sort': 'getItemsByCategory'
    };

    AppView.prototype.performSearch = function(event) {
      var id, performSearchResult, val,
        _this = this;
      val = jQuery(event.target).val();
      id = jQuery(event.target).attr('id');
      if (this.valueHasChanged(val, id)) {
        if (val === '') {
          clearTimeout(this.searchTimeout);
          performSearchResult = this.list.getItemsBySearch();
          return this.list.appendItems(performSearchResult);
        } else {
          clearTimeout(this.searchTimeout);
          return this.searchTimeout = setTimeout(function() {
            performSearchResult = _this.list.getItemsBySearch(val);
            return _this.list.appendItems(performSearchResult);
          }, 10);
        }
      }
    };

    AppView.prototype.initialize = function() {
      var _this = this;
      this.functionLog('initialize()');
      _.bindAll(this);
      this.list.allTranslations.fetch({
        url: 'content/manisch.json',
        success: function(model) {
          return _this.list.appendItems(_this.list.allTranslations);
        }
      });
      this.list.render(this.list.getItemsByCategory('all'));
      this.setFocusToFirstInput();
      jQuery('.sort').on('click', function(event) {
        var categoryName;
        _this.stopSearch();
        jQuery('#search').val('');
        _this.setFocusToFirstInput();
        categoryName = jQuery(event.target).attr('id');
        return _this.list.appendItems(_this.list.getItemsByCategory(categoryName));
      });
      jQuery('#search').on('keyup', function(event) {
        return _this.performSearch(event);
      });
      this.navHeight = jQuery('#secondary .top-bar').offset().top;
      jQuery(window).on('scroll', function() {
        return _this.performScrollCheck();
      });
      jQuery(window).on('resize', function() {
        jQuery('body').removeClass('fixsearch');
        _this.navHeight = jQuery('#secondary .top-bar').offset().top;
        return _this.performScrollCheck();
      });
      return setTimeout(function() {
        return jQuery('body').animate({
          scrollTop: jQuery('#secondary .top-bar').offset().top
        }, 400);
      }, 500);
    };

    return AppView;

  })(pxwrkHelpersForViews);

  App = new AppView;

}).call(this);
