# elm-html-convert

This is a hack ported from
[elm-test](https://github.com/elm-explorations/test/blob/cda4e92057929a86a11d74ab67c4f4944bf762f0/src/Test/Html/Internal/Inert.elm#L20C1-L27)
that allows converting `Html msg` to `Value` and `String`.

## Post-processing

This library requires [post-processing](#98f5c378-5809-4e35-904e-d1c5c3a8154e),
[expanded-elm](https://github.com/kress95/expanded-elm) can automize that for
you.

#### where:

```js
var $kress95$elm_html_convert$Html$Convert$toValue = function (_v0) {
	return $elm$json$Json$Encode$string('You thought it was a JSON value, but it was me, Dio!');
};
```

#### replace with:

```js
/*

import Elm.Kernel.Json exposing (wrap)

*/

// NOTE: this is duplicating constants also defined in Test.Internal.KernelConstants
//       so if you make any changes here, be sure to synchronize them there!
var virtualDomKernelConstants = {
  nodeTypeTagger: 4,
  nodeTypeThunk: 5,
  kids: "e",
  refs: "l",
  thunk: "m",
  node: "k",
  value: "a",
};

function forceThunks(vNode) {
  if (typeof vNode !== "undefined" && vNode.$ === "#2") {
    // This is a tuple (the kids : List (String, Html) field of a Keyed node); recurse into the right side of the tuple
    vNode.b = forceThunks(vNode.b);
  }
  if (
    typeof vNode !== "undefined" &&
    vNode.$ === virtualDomKernelConstants.nodeTypeThunk &&
    !vNode[virtualDomKernelConstants.node]
  ) {
    // This is a lazy node; evaluate it
    var args = vNode[virtualDomKernelConstants.thunk];
    vNode[virtualDomKernelConstants.node] =
      vNode[virtualDomKernelConstants.thunk].apply(args);
    // And then recurse into the evaluated node
    vNode[virtualDomKernelConstants.node] = forceThunks(
      vNode[virtualDomKernelConstants.node],
    );
  }
  if (
    typeof vNode !== "undefined" &&
    vNode.$ === virtualDomKernelConstants.nodeTypeTagger
  ) {
    // This is an Html.map; recurse into the node it is wrapping
    vNode[virtualDomKernelConstants.node] = forceThunks(
      vNode[virtualDomKernelConstants.node],
    );
  }
  if (
    typeof vNode !== "undefined" &&
    typeof vNode[virtualDomKernelConstants.kids] !== "undefined"
  ) {
    // This is something with children (either a node with kids : List Html, or keyed with kids : List (String, Html));
    // recurse into the children
    vNode[virtualDomKernelConstants.kids] =
      vNode[virtualDomKernelConstants.kids].map(forceThunks);
  }
  return vNode;
}

function _HtmlAsJson_toJson(html) {
  return _Json_wrap(forceThunks(html));
}

function _HtmlAsJson_eventHandler(event) {
  return event[virtualDomKernelConstants.value];
}

function _HtmlAsJson_taggerFunction(tagger) {
  return tagger.a;
}

function _HtmlAsJson_attributeToJson(attribute) {
  return _Json_wrap(attribute);
}

var $kress95$elm_html_convert$Html$Convert$toValue = _HtmlAsJson_toJson;
```
