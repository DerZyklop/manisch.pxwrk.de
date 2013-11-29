var PxwrkLib;

PxwrkLib = (function() {
  function PxwrkLib() {}

  PxwrkLib.prototype.functionLog = function(name) {
    return name;
  };

  PxwrkLib.prototype.valueHasChanged = (function() {
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

  return PxwrkLib;

})();

var PxwrkViewLib, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PxwrkViewLib = (function(_super) {
  __extends(PxwrkViewLib, _super);

  function PxwrkViewLib() {
    _ref = PxwrkViewLib.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PxwrkViewLib.prototype.itemDetailTmpl = (function() {
    var result;
    result = '';
    jQuery.ajax({
      url: '/site/templates/item-detail.html',
      async: false,
      success: function(data) {
        return result = data;
      }
    });
    return result;
  })();

  PxwrkViewLib.prototype.itemTmpl = (function() {
    var result;
    result = '';
    jQuery.ajax({
      url: '/site/templates/item.html',
      async: false,
      success: function(data) {
        return result = data;
      }
    });
    return result;
  })();

  return PxwrkViewLib;

})(Backbone.View);

var Item, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Item = (function(_super) {
  __extends(Item, _super);

  function Item() {
    _ref = Item.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Item.prototype.defaults = {
    id: 'Fehler! ID fehlt'
  };

  Item.prototype.initialize = function() {
    if (!this.get('manisch')) {
      throw new Error('manisch translation is missing');
    }
    if (!this.get('german')) {
      throw new Error('german translation is missing');
    }
  };

  return Item;

})(Backbone.Model);

var ItemView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ItemView = (function(_super) {
  __extends(ItemView, _super);

  function ItemView() {
    _ref = ItemView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ItemView.prototype.tagName = 'li';

  ItemView.prototype.initialize = function() {
    _.bindAll(this);
    if (!this.model) {
      throw new Error('model is required');
    }
    if (this.model.constructor.name !== 'Item') {
      throw new Error('model is not an instance of Item');
    }
  };

  ItemView.prototype.events = {
    'click': 'showItemDetail'
  };

  ItemView.prototype.render = function() {
    pxwrk.functionLog('ItemView.render()');
    if (this.itemTmpl) {
      jQuery(this.el).html(_.template(this.itemTmpl, this.model.toJSON()));
    } else {
      jQuery(this.el).html('Error: Missing Template');
    }
    return this;
  };

  ItemView.prototype.unrender = function() {
    pxwrk.functionLog('ItemView.unrender()');
    this.remove();
    return this;
  };

  ItemView.prototype.renderItemDetailView = function() {
    var itemDetailView;
    itemDetailView = new ItemDetailView({
      model: this.model
    });
    return itemDetailView.render();
  };

  ItemView.prototype.showItemDetail = function() {
    return this.renderItemDetailView().show();
  };

  return ItemView;

})(PxwrkViewLib);

var ItemDetailView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ItemDetailView = (function(_super) {
  var fadeDuration;

  __extends(ItemDetailView, _super);

  function ItemDetailView() {
    _ref = ItemDetailView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ItemDetailView.prototype.tagName = 'div';

  ItemDetailView.prototype.id = 'item-detail-view';

  ItemDetailView.prototype.events = {
    'click': 'unrenderCheck',
    'click a': 'unrender',
    'click .close': 'unrender'
  };

  fadeDuration = 0;

  ItemDetailView.prototype.itemHtml = function() {
    return _.template(this.itemTmpl, this.model.toJSON());
  };

  ItemDetailView.prototype.viewHtml = function() {
    var item;
    if (this.model) {
      return item = _.template(this.itemDetailTmpl, {
        content: this.itemHtml(),
        item: this.model.toJSON()
      });
    } else {
      return item = _.template(this.itemDetailTmpl, {
        content: 'Ulai! Isch kann die Übersetzung net finde. Da fällt mer <a href="#cat/alle/search/härles/">härles</a> aach ke <a href="#cat/alle/search/linkeresko/">linkeresko</a> ei!',
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
    jQuery(this.el).html(this.viewHtml());
    return this;
  };

  ItemDetailView.prototype.show = function() {
    var url;
    url = router.getNewUrl();
    if (this.model) {
      url += 'item/' + this.model.toJSON().id;
    }
    router.navigate(url, {
      trigger: false
    });
    this.$el.css('display', 'none');
    jQuery('body').append(this.el);
    this.$el.fadeIn(fadeDuration);
    this.$el.find('.button').focus();
    return this;
  };

  ItemDetailView.prototype.unrenderCheck = function(event) {
    if (event.target.id === 'item-detail-view') {
      return this.unrender(event);
    }
  };

  ItemDetailView.prototype.unrender = function(event) {
    jQuery(document).off('keyup');
    return this.$el.fadeOut(fadeDuration, function() {
      var url;
      this.remove();
      url = router.getNewUrl();
      return router.navigate(url, {
        trigger: false
      });
    });
  };

  return ItemDetailView;

})(PxwrkViewLib);

var List, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

List = (function(_super) {
  __extends(List, _super);

  function List() {
    _ref = List.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  List.prototype.model = Item;

  List.prototype.url = '/translations';

  List.prototype.fetch = function(options) {
    options = options || {};
    options.async = false;
    return List.__super__.fetch.call(this, options);
  };

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

var ListView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ListView = (function(_super) {
  __extends(ListView, _super);

  function ListView() {
    _ref = ListView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ListView.prototype.tagName = 'ul';

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
    _.each(this.visibleItems.models, function(item) {
      return _this.appendItem(item);
    });
    return this;
  };

  ListView.prototype.show = function() {
    return app.$el.find('#list-view').append(this.el);
  };

  ListView.prototype.deactivateInfo = function() {
    var el;
    el = jQuery('#bottom-list-info');
    if (!el.hasClass('inactive')) {
      return el.addClass('inactive');
    }
  };

  ListView.prototype.render = function() {
    pxwrk.functionLog('render()');
    this.deactivateInfo();
    this.appendItems().show();
    return this;
  };

  ListView.prototype.unrender = function() {
    return jQuery(this.el).html('');
  };

  return ListView;

})(PxwrkViewLib);

var AppView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

AppView = (function(_super) {
  var isColored;

  __extends(AppView, _super);

  function AppView() {
    this.loadListInBackground = __bind(this.loadListInBackground, this);
    _ref = AppView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  AppView.prototype.tmpl = (function() {
    var result;
    result = '';
    jQuery.ajax({
      url: '/site/templates/app.html',
      async: false,
      success: function(data) {
        return result = data;
      }
    });
    return result;
  })();

  AppView.prototype.className = 'page-wrap';

  AppView.prototype.events = {
    'keyup #search': 'performSearch',
    'change #search': 'performSearch',
    'submit #searchform': 'preventSubmit',
    'keyup #primary': 'keyNav'
  };

  AppView.prototype.listView = new ListView;

  AppView.prototype.render = function() {
    pxwrk.functionLog('AppView.render()');
    if (this.tmpl) {
      jQuery(this.el).html(this.tmpl);
    } else {
      jQuery(this.el).html('Error: Missing Template');
    }
    return this;
  };

  AppView.prototype.show = function() {
    pxwrk.functionLog('AppView.render()');
    jQuery('body#manischapp').html(this.el);
    return this;
  };

  AppView.prototype.navHeight = function() {
    var _ref1;
    return (_ref1 = jQuery('#secondary .top-bar').offset()) != null ? _ref1.top : void 0;
  };

  AppView.prototype.keyNav = function(event) {
    var el, url;
    console.log(this.$el.find('#' + event.target.id).prev());
    el = this.$el.find('#' + event.target.id);
    switch (event.keyCode) {
      case 38:
        el = el.prev();
        url = el.attr('href');
        router.navigate(url, {
          trigger: true
        });
        el.focus();
        console.log('hoch');
        break;
      case 40:
        el = el.next();
        url = el.attr('href');
        router.navigate(url, {
          trigger: true
        });
        el.focus();
        console.log('runter');
        break;
      case 39:
        console.log('rechts');
        break;
      case 37:
        console.log('links');
    }
  };

  isColored = false;

  AppView.prototype.preventSubmit = function(event) {
    var backgroundColor, elements;
    event.preventDefault();
    if (!isColored) {
      isColored = true;
      elements = jQuery('#itemview .german');
      jQuery.merge(elements, jQuery('#itemview .manisch'));
      backgroundColor = jQuery(elements[0]).css('color');
      elements.css('color', '#070');
      return setTimeout(function() {
        elements.css({
          'color': backgroundColor
        });
        return isColored = false;
      }, 500);
    }
  };

  AppView.prototype.performSearch = function(event) {
    return router.navigate(router.getNewUrl(), {
      trigger: true
    });
  };

  AppView.prototype.setFocusToFirstInput = function() {};

  AppView.prototype.performScrollCheck = function() {
    var currentNavHeight;
    currentNavHeight = this.navHeight();
    if (jQuery('body').hasClass('fixsearch')) {
      if (currentNavHeight && jQuery(window).scrollTop() < currentNavHeight) {
        return jQuery('body').removeClass('fixsearch');
      }
    } else {
      if (currentNavHeight && jQuery(window).scrollTop() > currentNavHeight) {
        return jQuery('body').addClass('fixsearch');
      }
    }
  };

  AppView.prototype.listRequest = function(params) {
    pxwrk.functionLog('listRequest()');
    if (jQuery('#search').val() !== params.search) {
      jQuery('#search').val(params.search);
    }
    if (pxwrk.valueHasChanged(params.search, 'search') || pxwrk.valueHasChanged(params.category, 'category')) {
      return this.listView.getFilteredList(params);
    }
  };

  AppView.prototype.clearSearchInput = function() {
    return jQuery('#search').val('');
  };

  AppView.prototype.setRandomParams = function() {
    var category, params;
    if (router.currentCat.get()) {
      category = router.currentCat.get();
    } else {
      category = 'alle';
    }
    return params = {
      category: category,
      search: '',
      id: _.random(1, translations.length).toString()
    };
  };

  AppView.prototype.loadListInBackground = function(params) {
    if (!router.currentCat.get()) {
      this.listRequest(params);
      return this.listView.render();
    }
  };

  AppView.prototype.randomItemRequest = function() {
    var params;
    params = this.setRandomParams();
    this.clearSearchInput();
    this.loadListInBackground(params);
    return this.showItemDetail(params);
  };

  AppView.prototype.showItemDetail = function(params) {
    var item, itemDetailView, items;
    items = translations.category('alle').search('');
    item = items.findWhere({
      id: parseFloat(params.id)
    });
    itemDetailView = new ItemDetailView({
      model: item
    });
    return itemDetailView.render().show();
  };

  AppView.prototype.initialize = function() {
    var _this = this;
    pxwrk.functionLog('initialize()');
    _.bindAll(this);
    this.render().show();
    this.setFocusToFirstInput();
    jQuery(window).on('scroll', function() {
      return _this.performScrollCheck();
    });
    return jQuery(window).on('resize', function() {
      jQuery('body').removeClass('fixsearch');
      return _this.performScrollCheck();
    });
  };

  return AppView;

})(PxwrkViewLib);

var Router, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Router = (function(_super) {
  __extends(Router, _super);

  function Router() {
    _ref = Router.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Router.prototype.routes = {
    "(cat/:category)(/)(search/:search)/": "showFilteredList",
    "random/": "showRandomItems",
    "(cat/:category/)(search/:search/)item/:itemid": "showItem"
  };

  Router.prototype.beforeNavigate = function(params) {
    app.$el.find('#primary .active').removeClass('active');
    return app.$el.find('#' + params.category + '-btn').addClass('active');
  };

  Router.prototype.getNewUrl = function() {
    var url;
    pxwrk.functionLog('getNewUrl');
    url = '';
    if (this.currentCat.get()) {
      url += 'cat/' + this.currentCat.get() + '/';
    }
    if (jQuery('#search').val()) {
      url += 'search/' + jQuery('#search').val() + '/';
    }
    return url;
  };

  Router.prototype.showFilteredList = function(category, search) {
    var params;
    if (category == null) {
      category = 'alle';
    }
    if (search == null) {
      search = '';
    }
    params = {
      category: category,
      search: search
    };
    this.beforeNavigate(params);
    pxwrk.functionLog('showFilteredList');
    this.currentCat.set(params.category);
    app.listView.unrender();
    app.listRequest(params);
    app.listView.render();
    return app;
  };

  Router.prototype.currentCat = (function() {
    var currentCategory;
    currentCategory = false;
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
    pxwrk.functionLog('showRandomItems');
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

var app, pxwrk, router, translations;

pxwrk = new PxwrkLib;

translations = new List;

translations.fetch({
  error: function(data) {},
  success: function(data) {}
});

app = new AppView;

app.render();

router = new Router;

Backbone.history.start();
