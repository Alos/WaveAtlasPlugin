
@import <Foundation/CPObject.j>

@implementation CPWaveView : CPView
{
    DOMElement  wp_DOMWaveElement;
    Object _wavePanel;
    CPString _waveID @accessors;
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void) _buildDOM
{
    performWhenGoogleScriptLoaded(function()
    {
        wp_DOMWaveElement = document.createElement("div");
        wp_DOMWaveElement.id = "WPWaveView" + [self UID];

        var style = m_DOMMapElement.style,
            bounds = [self bounds],
            width = CGRectGetWidth(bounds),
            height = CGRectGetHeight(bounds);

        style.overflow = "hidden";
        style.position = "absolute";
        style.visibility = "visible";
        style.zIndex = 0;
        style.left = -width + "px";
        style.top = -height + "px";
        style.width = width + "px";
        style.height = height + "px";
    
        document.body.appendChild(wp_DOMWaveElement);

        var embedOptions = {
            target: wp_DOMWaveElement,
            rootUrl: 'http://wave.google.com/a/wavesandbox.com/'
        }

        _wavePanel = new google.wave.WavePanel(embedOptions);
        _wavePanel.loadWave("googlewave.com"+_waveID);
    }

}

@end

var GoogleScriptQueue   = [];

var performWhenGoogleScriptLoaded = function(/*Function*/ aFunction)
{
    GoogleScriptQueue.push(aFunction);

    performWhenGoogleScriptLoaded = function()
    {
        GoogleScriptQueue.push(aFunction);
    }

    // Maps is already loaded
    if (window.google)
        _WPWaveViewGoogleAjaxLoaderLoaded();

    else
    {
        var DOMScriptElement = document.createElement("script");

        DOMScriptElement.src = "http://www.google.com/jsapi?callback=_WPWaveViewGoogleAjaxLoaderLoaded";
        DOMScriptElement.type = "text/javascript";

        document.getElementsByTagName("head")[0].appendChild(DOMScriptElement);
    }
}

function _WPWaveViewGoogleAjaxLoaderLoaded()
{
    google.load("wave", 1);
    [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
}

@implementation CPWaveView (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [self setWaveID:[aCoder decodeObjectForKey:"WAVEID"]];
        [self _buildDOM];
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[self _waveID] forKey:"WAVEID"];
}

@end