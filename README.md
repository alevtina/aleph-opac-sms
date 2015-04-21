Texting from the Aleph OPAC
===========================

This feature allows patrons to send holdings data about items to their mobile phones. Users must simply navigate to an item's holding page and click on the button titled "Send Info via Text." They will then need to enter their phone number and cellular carrier to receive a text message with the title, location, and call number of the selected item. This is done **without** a dedicated SMS server and relies, instead, on the Net::SMTP Perl module to send the messages. (You will need to know your institution's mail server.)

Compatibility
-------------

This code was created for Aleph v18. It has also proven to work in Aleph v21.

Live Demonstration
------------------

[http://libsearch.cuny.edu/F/?func=item-global&doc_library=CUN01&doc_number=006335213](http://libsearch.cuny.edu/F/?func=item-global&doc_library=CUN01&doc_number=006335213)

Installation Instructions
-------------------------

**Add new CSS class ("sms") to style the popup box**

$ wf

$ vi exlibris-xxx01.css

    ...
    #sms {
        width: 250px;
        font-family: arial, helvetica, sans-serif;
        font-size: 70%;
        border: 1px solid #36647B;
        position: absolute;
        left: 50%;
        top: 50%;
        z-index: 1000;
        padding: 10px;
        margin: 10px;
        background: #EFEFCF;
    }

**Add table ID ("bib-items") so JavaScript will find table with holding info**

$ wf

$ vi item-global-body-head

    ...
    <table ... id="bib-items">
    ...

**Add JavaScript to hide "Send Info via Text" button if there is no item data available**

$ wf

$ vi item-global-body-tail

    ...
    <script>
    var itms = document.getElementById('bib-items');
    var tr = itms.getElementsByTagName('tr');
    for( var i = 1; i < tr.length; i++ ) {
        var td = tr[i].getElementsByTagName('td');
        // our bib items table has 8 columns (if
        // item exists) -- yours may be different
        if( td.length !== 8 ) {
            document.getElementById('smslink').style.visibility='hidden';
        }
    }
    </script>
    ...

**Add "Send Info via Text" button (span ID "smslink") and create new span tag (ID "sms") to display form**

$ wf

$ vi item-global-dropdown-menus-a

    ...
    <span id="smslink">
    <a href="#" name="smslink" id="smslink" onClick="showSMS();return false;">Send Info via Text</a>
    </span>
    ...
    <span id="sms" style="visibility:hidden;display:none;"></span>
    ...

**Include sms-js file in the holdings page header and add table ID ("bib-detail") for JavaScript**

$ wf

$ vi item-global-head-1

    ...
    <include>sms-js
    ...
    <table id="bib-detail">
    ...

**In cgi-bin, write Perl script ("sms.pl"), remembering to chmod 0755**

**In web directory, write JavaScript ("sms-js") file**

**If your library is like CUNY, item titles on holdings pages will need to be somehow identified as titles**

We added a trailing slash to the titles:

$ cd $xxx01_dev/xxx01/tab

$ vi edit_paragraph.eng

    !*   Author-Title for Bib Inf
    013 1#### D           ^:^
    013 245## 9 ##        ^/^
    013 250## D ##        .
    013 260## W ##^       .
    013 300## D ##^       .

**If using above: Include small JavaScript in footer to remove slash (after SMS script has had a chance to run)**

$ wf

$ vi item-global-tail-1

    ...
    <script>
    // some titles end with two slashes (//) and, because
    // this is not a desired behavior, we are replacing
    // the two slashes with just one slash
    var bib = document.getElementById( 'bib-detail' );
    var x = bib.rows;
    for( var i = 0; i < x.length; i++ )
    {
        var y = x[i].cells;
        for( var j = 0; j < y.length; j++ )
        {
            var txt = y[j].innerHTML;
            y[j].innerHTML = txt.replace( /\/\//g, "/" );
        }
    }
    </script>

Acknowledgements
----------------

This code was originally created for Innovative Interface OPAC by Adam Brin (Bryn Mawr College) in ~2005-2008.