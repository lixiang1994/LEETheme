
//初始化设置

function initial(info){
 
    //设置字体颜色
    
    configFontColor(info["fontColor"]);
    
    //设置字体大小
    
    configFontSize(info["fontSize"]);
    
    //设置背景颜色
    
    configBackgroundColor(info["backgroundColor"]);
    
    //是否点击加载
    
    var isClickLoad = info["isClickLoad"];
    
    //为图片标签增加点击事件
    
    var imgs = $("body").find("img.image");
    
    for(var i = 0; i < imgs.length; i++){
        
        var img = imgs.eq(i);
        
        img.attr({"data-index": i , "data-state": isClickLoad ? 3 : 0});
        
        configImgState(isClickLoad ? 3 : 0 , i);
    }
    
    $("body").find("img.image").click(function(){
                                    
                                      var _this = $(this);
                                      
                                      var index = _this.attr("data-index");
                                      
                                      var url = _this.attr("src");
                                      
                                      var state = _this.attr("data-state");
                                      
                                      if (state == 2 || state == 3) {
                                      
                                        window.webkit.messageHandlers.showImage.postMessage(index);
                                      }
                                      
                                      if (state == 4) {
                                      
                                        window.webkit.messageHandlers.clickImage.postMessage({index:index , url:url});
                                      }
                                      
                                });
    
}

/**
 设置背景颜色
 
 @param color       颜色字符串 ('FFFFFF')
 @param className   元素名称或id或class (选填 空为body)
 */
function configBackgroundColor(color,className){
    
    var o = className == undefined ? "html" : className;
    
    $(o).css({"background-color" : color});
}

/**
 设置字体颜色
 
 @param color       颜色字符串 ('FFFFFF')
 @param className   元素名称或id或class (选填 空为body)
 */
function configFontColor(color,className){
    
    var o = className == undefined ? "body" : className;
    
    $(o).css({"color" : color});
}

/**
 设置字体大小
 
 @param size        字号 ('20')
 @param className   元素名称或id或class (选填 空为body)
 */
function configFontSize(size,className){
    
    var o = className == undefined ? "body" : className;
    
    $(o).css({"font-size" : parseFloat(size) + "px"});
}

/**
 获取图片url
 
 @param index       下标 ('1')
 @param className   元素名称或id或class (选填 空为body)
 */
function getImageUrl(index,className){
   
    var o = className == undefined ? "body" : className;
    
    var img = $(o).find("img.image").eq(parseFloat(index));
    
    if(!img) return; //没有找到图片
    
    return img.attr("data-src");
}

/**
 设置图片url
 
 @param index       下标 ('1')
 @param url         图片url ('http://lixiang.png')
 @param className   元素名称或id或class (选填 空为body)
 */
function setImageUrl(index, url, className){
    
    var o = className == undefined ? "body" : className;
    
    $(o).find("img.image").eq(parseFloat(index)).attr("src" , url)
}

//返回当前显示的图片  暂时用不上了
/*
$(window).scroll(function(){
            
                 var imgs = $("img.image");
                 
                 for(var i = 0; i < imgs.length; i++){
                 
                    var img = imgs.eq(i);
                 
                    if(!img.attr("show") && img.attr("data-state") == 0){
                 
                        if($(window).scrollTop() + $(window).height() > img.offset().top){
                 
                            img.attr("show","1");
                 
                            window.webkit.messageHandlers.showImage.postMessage(img.attr("data-index"));
                        }
                 
                    }
                 
                 }

});

 */

/**
 设置Img状态
 
 @param state       状态码 [0:初始加载] [1:加载中] [2:加载失败] [3:点击加载] [4:加载完成]
 @param index       下标 ('1')
 @param className   元素名称或id或class (选填 空为body)
 */
function configImgState(state, index, className){
    
    var o = className == undefined ? "body" : className;
    
    var oImg = $(o).find("img.image").eq(index);
    
    state = parseFloat(state);
    
    switch (state) {
            
        case 0:
            oImg.attr({"src":"../contentimage/load_image_initload.png" , "alt":"米尔军事" , "data-state":0});
            break;
        case 1:
            oImg.attr({"src":"../contentimage/load_image_loading.png" , "alt":"加载中" , "data-state":1}); //添加加载图片的路径
            break;
        case 2:
            oImg.attr({"src":"../contentimage/load_image_loadfail.png" , "alt":"加载失败" , "data-state":2});
            break;
        case 3:
            oImg.attr({"src":"../contentimage/load_image_clickload.png" , "alt":"点击加载" , "data-state":3});
            break;
        case 4:
            oImg.attr({"src":"" , "alt":"" , "data-state":4}).css({"height":"auto"}); //src添加图片的路径
            break;
    }

}

/**
 设置图片大小
 
 @param index       下标 ('1')
 @param width       宽度 px
 @param height      高度 px
 @param className   元素名称或id或class (选填 空为body)
 */
function configImgSize(index, width, height, className){
    
    var o = className == undefined ? "body" : className;
    
    var oImg = $(o).find("img.image").eq(index);
    
    oImg.attr({"width":width,"height":height})
}

/**
 返回Img个数
 
 @param className   元素名称或id或class (选填 空为body)
 */
function getImageCount(className){
    
    var o = className == undefined ? "body" : className;
    
    var len = $(o).find("img.image").length;
    
    return len;
}

/**
 返回所有图片Url
 
 @param className   元素名称或id或class (选填 空为body)
 */
function getImageUrls(className){
    
    var ary = [];
    
    var o = className == undefined ? "body" : className;
    
    var oImgs = $(o).find("img.image");
    
    for(var i = 0; i < oImgs.length; i++){
        
        ary[ary.length] = oImgs.eq(i).attr("data-src");
    }
    
    return ary;
}

/**
 返回文字内容
 
 @param className   元素名称或id或class (选填 空为body)
 */
function getContentString(className){
    
    var str = "";
    
    var o = className == undefined ? "body" : className;
    
    str = $(o).text();
    
    return str;
}

/**
 返回内容高度
 
 @param className   元素名称或id或class (选填 空为body)
 */
function getContentHeight(className){
    
    var o = className == undefined ? "body" : className;
    
    var div = $(o).find("div.content");
    
    return div.outerHeight(true);
}
