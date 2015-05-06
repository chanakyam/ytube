	var app = angular.module('speakglobalApp', ['ui.bootstrap']);

app.factory('speakglobalHomePageService', function ($http) {
	return {
		getVideosCount: function () {
			return $http.get('/api/videos/count').then(function (result) {
				return result.data.total_rows;
			});
		},
		getNoneFeaturedVideos: function (videosPerPage, skipValue) {
			return $http.get('/api/videos/featured_none?limit=' + videosPerPage + '&skip=' + skipValue).then(function (result) {
			return result.data.articles;
			});
		},
		getLatestVideos: function () {
			return $http.get('/api/videos/latest').then(function (result) {
				return result.data.rows;
			});
		},
		getPopularVideos: function (count) {
			return $http.get('/api/videos/popular?n=' + count+'&skip=10').then(function (result) {
				return result.data.articles;
			});
		},
		getPopularHomeVideos: function (count) {
			return $http.get('/api/homevideos/popular?n=' + count+'&skip=10').then(function (result) {
				return result.data.rows;
			});
		},
		getHomeVideo: function (){
			return $http.get('/api/videos/home_video').then(function (result){				
				return result.data;
			});
		}
	};
});

// Single Video Page Serives
app.factory('speakglobalVideoPageService', function ($http) {
	return {
		getVideoDetails: function (vId){
			return $http.get('/api/videos/single_video/' + vId).then(function (result){
				return result.data;
			});
		}
	};
});

// Similar Videos Page Serives
app.factory('speakglobalSimilarVideosPageService', function ($http) {
	return {
		getSimilarVideosCount: function () {
			return $http.get('/api/videos/count').then(function (result) {
				return result.data.rows;
			});
		},
		getSimilarVideos: function (videosPerPage, skipValue) {
			return $http.get('/api/videos/featured_none?limit=' + videosPerPage + '&skip=' + skipValue).then(function (result) {
				return result.data.rows;
			});
		},
		getLatestVideos: function () {
			return $http.get('/api/videos/latest').then(function (result) {
				return result.data.rows;
			});
		}
	};
});
// flowplayer-flash factory
app.factory("flowplayer", function(){
	return flowplayer;
});

// Home Page Controller
app.controller('SpeakglobalHome', function ($scope, speakglobalHomePageService, $window, $log,flowplayer,$document) {
	
	// Get the top 10 popular videos List
	$scope.currentYear = (new Date).getFullYear();
	$scope.popularVideos    = speakglobalHomePageService.getPopularVideos(10);
		
	$scope.video = " http://video.contentapi.ws/2014-06-30T183750Z_1_LOVEA5T1FR1Y1_RTRMADV_STREAM-700-16X9-MP4_WEST-BANK-TEENAGERS-O.MP4";		 
	$scope.videoTitle = "Bodies of three missing teens found in West Bank-Israeli media";
	$scope.videoDescription = "Israeli security forces find the bodies of three teenagers who went missing in the West Bank earlier this month, local media says. Deborah Lutterbeck reports.";

 	// start of code for generating cb,pagetit,pageurl
 	var vastURI = 'http://vast.optimatic.com/vast/getVast.aspx?id=s93akgl0y&zone=vpaidtag&pageURL=[INSERT_PAGE_URL]&pageTitle=[INSERT_PAGE_TITLE]&cb=[CACHE_BUSTER]';
	function updateURL(vastURI){
	// Generate a huge random number
	var ord=Math.random(), protocol, host, port, path, pageUrl, updatedURI;
	var parsedFragments = parseUri(vastURI);
	ord = ord * 10000000000000000000;
	// Protocol of VAST URI
	protocol = parsedFragments.protocol;
	// VAST URI hostname
	host = parsedFragments.host;
	// VAST URI Path
	path = parsedFragments.path;
	//VAST Page Url
	pageUrl = parsedFragments.queryKey.pageUrl
	var fragmentString ='';
	//Updated URI
	for(var key in parsedFragments.queryKey){//console.log("abhii");console.log();
		// For Cache buster add a large random number
		if(key == 'cb'){
			fragmentString = fragmentString + key + '=' + ord + '&';	
		}
		// for referring Page URL, get the current document URL and encode the URI
		else if(key == 'pageURL'){
			var currentUrl = document.URL;
			//var currentUrl = "http://test.com";
			fragmentString = fragmentString + key + '=' + currentUrl + '&';	
		}else if(key == 'pageTitle'){
			var page_title=document.title;
			fragmentString = fragmentString + key + '=' + page_title + '&';	
		}
		else{
			fragmentString = fragmentString + key + '=' + parsedFragments.queryKey[key] + '&';
		}
		
	}

	updatedURI = protocol + '://' + host + path + '?' + fragmentString ;
	
	// Remove the trailing & and return the updated URL
	return updatedURI.slice(0,-1);
	}

	// Parse URI to get qeury string like cb for cache buster and pageurl
function parseUri (str) {
	var	o   = parseUri.options,
		m   = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
		uri = {},
		i   = 14;

	while (i--) uri[o.key[i]] = m[i] || "";

	uri[o.q.name] = {};
	uri[o.key[12]].replace(o.q.parser, function ($0, $1, $2) {
		if ($1) uri[o.q.name][$1] = $2;
	});

	return uri;
};

parseUri.options = {
	strictMode: false,
	key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
	q:   {
		name:   "queryKey",
		parser: /(?:^|&)([^&=]*)=?([^&]*)/g
	},
	parser: {
		strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
		loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
	}
};
// end of code for generating cb,pagetit,pageurl

	


	$scope.adVidoe = function(){
		$(document).ready(function() {
			// var hvideo = $("#hid").val();
			// alert(hvideo);
			jwplayer('myElement').setup({
                  "flashplayer": "http://player.longtailvideo.com/player.swf",
                  "playlist": [
                    {
                      //"file": $scope.video
                      "file": $scope.video
                    }
                  ],
                  "width": 638,
                  "height": 364,
                  autostart: true,
                  "controlbar": {
                    "position": "bottom"
                  },
                  "plugins": {
                    "ova-jw": {
                      "ads": {
                        "companions": {
                          "regions": [
                            {
                              "id": "companion",
                              "width": 80,
                              "height": 300
                            }
                          ]
                        },
                        "schedule": [
                          {
                            "position": "pre-roll",
                            
                            "tag": updateURL(vastURI)
                          }
                        ]
                      },
                      "debug": {
                        "levels": "none"
                      }
                    }
                  }
                });
		})
	
	};
	// Non Featured Videos i.e all Videos
	$scope.videosPerPage = 42;

	// Javascript Custom Function to get teh URL params, decode them
	function getURLParameter (name) {
		return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
	}

	// Get all Video's Count
	$scope.videoCount = 250;
	// Generate the numberOfPages and pages content based on the videoCount
	$scope.$watch('videoCount', function (videoCountObj) {
		if (videoCountObj !== undefined) {
			$scope.numberOfPages = (Math.ceil(videoCountObj/$scope.videosPerPage)).toString();
			$scope.bigTotalItems = videoCountObj;
		}
	});

	// Get noneFeaturedVideos list based on the page(number) we are hitting from.
	$scope.currentPageNumber = parseInt(getURLParameter('p'), 10);
	if (isNaN($scope.currentPageNumber)) {
		skipValue = 0;
		$scope.currentPageNumber = 1;
	} else {
		skipValue = parseInt(($scope.currentPageNumber - 1) * $scope.videosPerPage, 10);
	}
	$scope.noneFeaturedVideos = speakglobalHomePageService.getNoneFeaturedVideos($scope.videosPerPage, skipValue);

	// Pagination plugin
	$scope.bigCurrentPage = $scope.currentPageNumber;
	$scope.maxSize = 6; // Max number of pages to be displayed at a time


	// Pagination plugin
	// This function is triggred when user tends to change the page using the plugin.
	$scope.pageChanged = function (page) {
		location.replace('/pages?p=' + page);
	};
});