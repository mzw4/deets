$(function() {

    Morris.Area({
        element: 'morris-area-chart',
        data: [{
            period: '2015-01-11 08:00:00',
            iphone: 2666,
            ipad: null,
            itouch: 2647
        }, {
            period: '2015-01-11 09:00:00',
            iphone: 2778,
            ipad: 2294,
            itouch: 2441
        }, {
            period: '2015-01-11 10:00:00',
            iphone: 4912,
            ipad: 1969,
            itouch: 2501
        }, {
            period: '2015-01-11 11:00:00',
            iphone: 3767,
            ipad: 3597,
            itouch: 5689
        }, {
            period: '2015-01-11 12:00:00',
            iphone: 6810,
            ipad: 1914,
            itouch: 2293
        }, {
            period: '2015-01-11 13:00:00',
            iphone: 5670,
            ipad: 4293,
            itouch: 1881
        }, {
            period: '2015-01-11 14:00:00',
            iphone: 4820,
            ipad: 3795,
            itouch: 1588
        }, {
            period: '2015-01-11 15:00:00',
            iphone: 15073,
            ipad: 5967,
            itouch: 5175
        }, {
            period: '2015-01-11 16:00:00',
            iphone: 10687,
            ipad: 4460,
            itouch: 2028
        }, {
            period: '2015-01-11 17:00:00',
            iphone: 8432,
            ipad: 5713,
            itouch: 1791
        }],
        xkey: 'period',
        ykeys: ['iphone', 'ipad', 'itouch'],
        labels: ['Registrations', 'Check-ins', 'Connections'],
        pointSize: 2,
        hideHover: 'auto',
        resize: true
    });

    Morris.Donut({
        element: 'morris-donut-chart',
        data: [{
            label: "Download Sales",
            value: 12
        }, {
            label: "In-Store Sales",
            value: 30
        }, {
            label: "Mail-Order Sales",
            value: 20
        }],
        resize: true
    });

    Morris.Bar({
        element: 'morris-bar-chart',
        data: [{
            y: '2006',
            a: 100,
            b: 90
        }, {
            y: '2007',
            a: 75,
            b: 65
        }, {
            y: '2008',
            a: 50,
            b: 40
        }, {
            y: '2009',
            a: 75,
            b: 65
        }, {
            y: '2010',
            a: 50,
            b: 40
        }, {
            y: '2011',
            a: 75,
            b: 65
        }, {
            y: '2012',
            a: 100,
            b: 90
        }],
        xkey: 'y',
        ykeys: ['a', 'b'],
        labels: ['Series A', 'Series B'],
        hideHover: 'auto',
        resize: true
    });

});
