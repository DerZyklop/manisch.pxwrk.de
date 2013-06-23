// Generated by CoffeeScript 1.6.1
(function() {
  var AppView, Item, ItemDetailView, ItemView, List, ListView, Router, pxwrkHelpersForViews, router,
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
       Begin itemDetailView.coffee
  --------------------------------------------
  */


  ItemDetailView = (function(_super) {

    __extends(ItemDetailView, _super);

    function ItemDetailView() {
      return ItemDetailView.__super__.constructor.apply(this, arguments);
    }

    ItemDetailView.prototype.tagName = 'div';

    ItemDetailView.prototype.id = 'dark-overlay';

    ItemDetailView.prototype.initialize = function() {
      return _.bindAll(this);
    };

    ItemDetailView.prototype.events = {
      'click': 'unrender'
    };

    ItemDetailView.prototype.itemDetail = function() {
      return console.log('itemDetail()');
    };

    ItemDetailView.prototype.render = function() {
      return jQuery(this.el).css({
        'background': '#000',
        'z-index': '200',
        'position': 'fixed',
        'top': '0',
        'bottom': '0',
        'left': '0',
        'right': '0'
      });
    };

    ItemDetailView.prototype.unrender = function() {
      return this.remove();
    };

    return ItemDetailView;

  })(pxwrkHelpersForViews);

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

    ItemView.prototype.events = {
      'click': 'itemDetail'
    };

    ItemView.prototype.itemDetail = function() {
      this.itemDetailView = new ItemDetailView({
        model: this.model
      });
      return this.itemDetailView.render();
    };

    ItemView.prototype.render = function(tmpl) {
      this.functionLog('ItemView.render()');
      if (tmpl) {
        jQuery(this.el).html(_.template(tmpl, this.model.toJSON()));
      } else {
        jQuery(this.el).html('Error: Missing Template');
      }
      return this;
    };

    ItemView.prototype.unrender = function() {
      this.functionLog('ItemView.unrender()');
      return this.remove();
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
      if (categoryName === 'alle') {
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

    ListView.prototype.el = '#list ul';

    ListView.prototype.allTranslations = new List;

    ListView.prototype.categoryTranslations = new List;

    ListView.prototype.visibleTranslations = new List;

    ListView.prototype.getItemsBySearch = function(searchParam) {
      if (searchParam == null) {
        searchParam = false;
      }
      this.functionLog('getItemsBySearch(' + searchParam + ')');
      this.unrender();
      this.visibleTranslations.reset(this.categoryTranslations.search(searchParam).toJSON());
      return this;
    };

    ListView.prototype.getItemsByCategory = function(categoryName) {
      this.functionLog('getItemsByCategory()');
      jQuery('.sort.active').removeClass('active');
      jQuery('#' + categoryName).addClass('active');
      this.unrender();
      this.categoryTranslations = this.allTranslations.byCategory(categoryName);
      this.visibleTranslations.reset(this.categoryTranslations.toJSON());
      return this;
    };

    ListView.prototype.appendItem = function(item) {
      var itemView;
      this.functionLog('appendItem()');
      itemView = new ItemView({
        model: item,
        tmpl: this.itemTmpl,
        className: this.getClassName(item, item.collection.length)
      });
      return $(this.el).append(itemView.render(this.itemTmpl).el);
    };

    ListView.prototype.getClassName = (function() {
      var itemsCounter, latestTranslation, translationsCounter;
      latestTranslation = false;
      translationsCounter = 0;
      itemsCounter = 0;
      return function(item, amount) {
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
        if (itemsCounter === amount) {
          translationsCounter = 0;
          itemsCounter = 0;
          latestTranslation = false;
        } else {
          latestTranslation = item.toJSON();
        }
        return result;
      };
    })();

    ListView.prototype.appendItems = function() {
      var html,
        _this = this;
      this.functionLog('appendItems()');
      html = '';
      return _.each(this.visibleTranslations.models, function(item) {
        return _this.appendItem(item);
      });
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
      this.functionLog('render()');
      return this.appendItems();
    };

    ListView.prototype.unrender = function() {
      return jQuery(this.el).html('');
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

    AppView.prototype.listView = new ListView;

    AppView.prototype.navHeight = jQuery('#secondary .top-bar').offset().top;

    AppView.prototype.setFocusToFirstInput = function() {};

    AppView.prototype.checkNavHeight = function() {
      jQuery('body').removeClass('fixsearch');
      return this.navHeight = jQuery('#secondary .top-bar').offset().top;
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

    AppView.prototype.searchRequest = function(val, id) {
      this.functionLog('searchRequest()');
      if (jQuery('#search').val() !== val) {
        jQuery('#search').val(val);
      }
      if (this.valueHasChanged(val, id)) {
        if (val === '') {
          return this.listView.getItemsBySearch();
        } else {
          return this.listView.getItemsBySearch(val);
        }
      }
    };

    AppView.prototype.categoryRequest = function(category) {
      jQuery('#search').val('');
      this.setFocusToFirstInput();
      this.listView.getItemsByCategory(category);
      jQuery('.active').removeClass('active');
      return jQuery('#' + category + '-btn').addClass('active');
    };

    AppView.prototype.initialize = function() {
      var _this = this;
      this.functionLog('initialize()');
      _.bindAll(this);
      this.listView.allTranslations.fetch({
        url: 'content/manisch.json',
        async: false
      });
      this.setFocusToFirstInput();
      jQuery(window).on('scroll', function() {
        return _this.performScrollCheck();
      });
      jQuery(window).on('resize', function() {
        _this.checkNavHeight();
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

  Router = Backbone.Router.extend({
    routes: {
      "cat/:categoryName(/search/:searchval)": "cat"
    },
    currentCat: 'alle',
    cat: function(categoryName, searchval) {
      if (searchval == null) {
        searchval = '';
      }
      console.log('GO!!!!!!');
      this.app.categoryRequest(categoryName);
      this.app.searchRequest(searchval, 'search');
      this.app.listView.render();
      return this.currentCat = categoryName;
    },
    initialize: function() {
      var that;
      this.app = new AppView;
      that = this;
      return jQuery('#search').on('keyup', function() {
        var url;
        url = 'cat/' + that.currentCat;
        if (jQuery(this).val()) {
          url += '/search/' + jQuery(this).val();
        }
        return that.navigate(url, {
          trigger: true
        });
      });
    },
    search: function(query, page) {}
  });

  router = new Router;

  router.on('route:alle', function() {
    return console.log('arg');
  });

  Backbone.history.start();

}).call(this);
