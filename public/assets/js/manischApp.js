// Generated by CoffeeScript 1.6.1
(function() {
  var AppView, Item, ItemDetailView, ItemView, List, ListView, Router, app, pxwrkHelpersForViews, router, translations,
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

    pxwrkHelpersForViews.prototype.itemDetailTmpl = (function() {
      var result;
      result = '';
      jQuery.ajax({
        url: 'site/templates/item-detail.html',
        async: false,
        success: function(data) {
          return result = data;
        }
      });
      return result;
    })();

    pxwrkHelpersForViews.prototype.itemTmpl = (function() {
      var result;
      result = '';
      jQuery.ajax({
        url: 'site/templates/item.html',
        async: false,
        success: function(data) {
          return result = data;
        }
      });
      return result;
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

    ItemDetailView.prototype.id = 'item-detail-view';

    ItemDetailView.prototype.events = {
      'click': 'unrenderCheck',
      'click a': 'unrender',
      'click .close': 'unrender'
    };

    ItemDetailView.prototype.itemHtml = function() {
      return _.template(this.itemTmpl, this.model.toJSON());
    };

    ItemDetailView.prototype.viewHtml = function() {
      var item;
      if (this.model) {
        return item = _.template(this.itemDetailTmpl, {
          content: this.itemHtml(),
          more: '(Hier kommt später eine Share-Funktion für Facebook und Twitter)'
        });
      } else {
        return item = _.template(this.itemDetailTmpl, {
          content: 'Ulai! Isch kann die Übersetzung net finde. Da fällt mer <a href="#cat/alle/search/härles">härles</a> aach ke <a href="#cat/alle/search/linkeresko">linkeresko</a> ei!',
          more: '(Hier kommt später eine Share-Funktion für Facebook und Twitter)'
        });
      }
    };

    ItemDetailView.prototype.initialize = function() {
      var _this = this;
      _.bindAll(this);
      return jQuery(document).on('keyup', function(event) {
        if (event.keyCode === 27) {
          return _this.unrender();
        }
      });
    };

    ItemDetailView.prototype.render = function() {
      return jQuery(this.el).html(this.viewHtml());
    };

    ItemDetailView.prototype.show = function() {
      var url;
      this.render();
      url = router.getNewUrl();
      if (this.model) {
        url += '/item/' + this.model.toJSON().id;
      }
      router.navigate(url, {
        trigger: false
      });
      this.$el.css('display', 'none');
      jQuery('body').append(this.el);
      return this.$el.fadeIn(200);
    };

    ItemDetailView.prototype.unrenderCheck = function(event) {
      if (event.target.id === 'item-detail-view') {
        return this.unrender(event);
      }
    };

    ItemDetailView.prototype.unrender = function(event) {
      jQuery(document).off('keyup');
      return this.$el.fadeOut(200, function() {
        var url;
        this.remove();
        url = router.getNewUrl();
        return router.navigate(url, {
          trigger: false
        });
      });
    };

    return ItemDetailView;

  })(pxwrkHelpersForViews);

  /* --------------------------------------------
       Begin Item.coffee
  --------------------------------------------
  */


  Item = (function(_super) {

    __extends(Item, _super);

    function Item() {
      return Item.__super__.constructor.apply(this, arguments);
    }

    Item.prototype.defaults = {
      id: 'Fehler! ID fehlt',
      manisch: 'Fehler! Übersetzung fehlt',
      german: 'Fehler! Übersetzung fehlt'
    };

    return Item;

  })(Backbone.Model);

  /* --------------------------------------------
       Begin ItemView.coffee
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
      'click': 'showItemDetail'
    };

    ItemView.prototype.showItemDetail = function() {
      var itemDetailView;
      itemDetailView = new ItemDetailView({
        model: this.model
      });
      return itemDetailView.show();
    };

    ItemView.prototype.render = function() {
      this.functionLog('ItemView.render()');
      if (this.itemTmpl) {
        jQuery(this.el).html(_.template(this.itemTmpl, this.model.toJSON()));
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

    List.prototype.category = function(categoryName) {
      var itemByCategory, result;
      if (categoryName === 'alle') {
        result = this;
      } else {
        itemByCategory = function(item) {
          return _.contains(item.get('category'), categoryName);
        };
        result = new List;
        result.add(this.filter(itemByCategory));
      }
      return result;
    };

    List.prototype.search = function(param) {
      var byInput, filtered,
        _this = this;
      if (!param) {
        return this;
      }
      byInput = function(element, index, array) {
        var attributes, pattern;
        attributes = element.toJSON();
        pattern = RegExp(param.toLowerCase());
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

    ListView.prototype.el = '#list-view ul';

    ListView.prototype.visibleItems = new List;

    ListView.prototype.getFilteredList = function(params) {
      var items;
      this.unrender();
      items = translations.category(params.category).search(params.search);
      this.visibleItems.reset(items.toJSON());
      return this;
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

    ListView.prototype.appendItem = function(item) {
      var itemView;
      itemView = new ItemView({
        model: item,
        className: this.getClassName(item, item.collection.length)
      });
      return $(this.el).append(itemView.render().el);
    };

    ListView.prototype.appendItems = function() {
      var _this = this;
      return _.each(this.visibleItems.models, function(item) {
        return _this.appendItem(item);
      });
    };

    ListView.prototype.deactivateInfo = function() {
      var el;
      el = jQuery('#bottom-list-info');
      if (!el.hasClass('inactive')) {
        return el.addClass('inactive');
      }
    };

    ListView.prototype.render = function() {
      this.functionLog('render()');
      this.deactivateInfo();
      return this.appendItems();
    };

    ListView.prototype.unrender = function() {
      return jQuery(this.el).html('');
    };

    return ListView;

  })(pxwrkHelpersForViews);

  /* --------------------------------------------
       Begin AppView.coffee
  --------------------------------------------
  */


  AppView = (function(_super) {

    __extends(AppView, _super);

    function AppView() {
      return AppView.__super__.constructor.apply(this, arguments);
    }

    AppView.prototype.el = 'body';

    AppView.prototype.events = {
      'keyup #search': 'performSearch'
    };

    AppView.prototype.listView = new ListView;

    AppView.prototype.navHeight = jQuery('#secondary .top-bar').offset().top;

    AppView.prototype.performSearch = function(event) {
      return router.navigate(router.getNewUrl(), {
        trigger: true
      });
    };

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

    AppView.prototype.listRequest = function(params) {
      this.functionLog('listRequest()');
      if (jQuery('#search').val() !== params.search) {
        jQuery('#search').val(params.search);
      }
      if (this.valueHasChanged(params.search, 'search') || this.valueHasChanged(params.category, 'category')) {
        return this.listView.getFilteredList(params);
      }
    };

    AppView.prototype.randomItemRequest = function() {
      var params;
      jQuery('#search').val('');
      params = {
        category: router.currentCat.get(),
        search: '',
        id: _.random(1, translations.length).toString()
      };
      if (params.category === 'alle') {
        this.listRequest(params);
        this.listView.render();
      }
      return this.showItemDetail(params);
    };

    AppView.prototype.showItemDetail = function(params) {
      var item, itemDetailView, items;
      items = translations.category('alle').search('');
      item = items.findWhere({
        id: params.id
      });
      itemDetailView = new ItemDetailView({
        model: item
      });
      return itemDetailView.show();
    };

    AppView.prototype.initialize = function() {
      var _this = this;
      this.functionLog('initialize()');
      _.bindAll(this);
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

  /* --------------------------------------------
       Begin Router.coffee
  --------------------------------------------
  */


  Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      "cat/:category(/search/:search)": "showFilteredList",
      "random": "showRandomItems",
      "cat/:category(/search/:search)/item/:itemid": "showItem"
    };

    Router.prototype.beforeNavigate = function(params) {
      jQuery('.active').removeClass('active');
      return jQuery('#' + params.category + '-btn').addClass('active');
    };

    Router.prototype.getNewUrl = function() {
      var url;
      console.log('getNewUrl');
      url = 'cat/' + this.currentCat.get();
      if (jQuery('#search').val()) {
        url += '/search/' + jQuery('#search').val();
      }
      return url;
    };

    Router.prototype.showFilteredList = function(category, search) {
      var params;
      if (search == null) {
        search = '';
      }
      params = {
        category: category,
        search: search
      };
      this.beforeNavigate(params);
      console.log('showFilteredList');
      this.currentCat.set(params.category);
      app.listView.unrender();
      app.listRequest(params);
      return app.listView.render();
    };

    Router.prototype.currentCat = (function() {
      var currentCategory;
      currentCategory = 'alle';
      return {
        set: function(newCat) {
          return currentCategory = newCat;
        },
        get: function() {
          return currentCategory;
        }
      };
    })();

    Router.prototype.showRandomItems = function() {
      console.log('showRandomItems');
      return app.randomItemRequest();
    };

    Router.prototype.showItem = function(category, search, id) {
      var params;
      params = {
        category: category,
        search: search,
        id: id
      };
      this.beforeNavigate(params);
      this.showFilteredList(category, search);
      return app.showItemDetail(params);
    };

    return Router;

  })(Backbone.Router);

  /* --------------------------------------------
       Begin manischApp.coffee
  --------------------------------------------
  */


  translations = new List;

  translations.fetch({
    url: 'translations',
    async: false,
    error: function(data) {},
    success: function(data) {}
  });

  app = new AppView;

  router = new Router;

  Backbone.history.start();

}).call(this);
