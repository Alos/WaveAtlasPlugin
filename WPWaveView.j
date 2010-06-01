
@import <Foundation/CPObject.j>

@implementation CPWaveView : CPView
{
    DOMElement  wp_DOMWaveElement;
    Object _wavePanel;
    CPString waveID @accessors;
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
        _wavePanel.loadWave("googlewave.com"+waveID);
}

@end


function prepareGoogleAPI()
{
    var DOMScriptElement = document.createElement("script");
    DOMScriptElement.src = "http://www.google.com/jsapi ?callback=_WPWaveViewGoogleAjaxLoaderLoaded";
    DOMScriptElement.type = "text/javascript";
    document.getElementsByTagName("head")[0].appendChild(DOMScriptElement);
}

function _WPWaveViewGoogleAjaxLoaderLoaded()
{   
    google.load("wave", 1);
    [self _buildDOM];
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