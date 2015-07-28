<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:w="http://wendellpiez.com/HaiKuML/xproc/util"
    version="1.0">
    
<!-- Queries JISHO.org and returns the HTML results as XML  -->
    <p:input port="source">
        <p:data href="http://jisho.org/search/%E4%BF%B3" wrapper="w:html5"/>
    </p:input>
    <p:output port="result"/>
        
    <p:unescape-markup content-type="text/html"/>
    
    <p:unwrap match="/*"/>
</p:declare-step>