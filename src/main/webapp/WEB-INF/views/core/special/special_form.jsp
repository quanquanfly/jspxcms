<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.jspxcms.com/tags/form"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>Jspxcms管理平台 - Powered by Jspxcms</title>
<jsp:include page="/WEB-INF/views/commons/head.jsp"></jsp:include>
<script type="text/javascript">
$(function() {
	$("#validForm").validate();
	$("input[name='name']").focus();
});
function confirmDelete() {
	return confirm("<s:message code='confirmDelete'/>");
}
function uploadFile(name,button) {
  if($("#f_"+name).val()=="") {alert("<s:message code='pleaseSelectTheFile'/>");return;}
  Cms.uploadFile("../upload_file.do",name,button);
}
function uploadVideo(name,button) {
  if($("#f_"+name).val()=="") {alert("<s:message code='pleaseSelectTheFile'/>");return;}
  Cms.uploadFile("../upload_video.do",name,button);
}
function uploadImg(name,button) {
	if($("#f_"+name).val()=="") {alert("<s:message code='pleaseSelectTheFile'/>");return;}
	Cms.uploadImg("../upload_image.do",name,button);
}
function imgCrop(name) {
	if($("#"+name).val()=="") {alert("<s:message code='noImageToCrop'/>");return;}
	Cms.imgCrop("../../commons/img_area_select.do",name);
}
</script>
</head>
<body class="c-body">
<jsp:include page="/WEB-INF/views/commons/show_message.jsp"/>
<div class="c-bar margin-top5">
  <span class="c-position"><s:message code="special.management"/> - <s:message code="${oprt=='edit' ? 'edit' : 'create'}"/></span>
</div>
<form id="validForm" action="${oprt=='edit' ? 'update' : 'save'}.do" method="post">
<tags:search_params/>
<f:hidden name="oid" value="${bean.id}"/>
<f:hidden name="position" value="${position}"/>
<input type="hidden" id="redirect" name="redirect" value="edit"/>
<table border="0" cellpadding="0" cellspacing="0" class="in-tb margin-top5">
  <tr>
    <td colspan="4" class="in-opt">
			<shiro:hasPermission name="core:special:create">
			<div class="in-btn"><input type="button" value="<s:message code="create"/>" onclick="location.href='create.do?modelId=${model.id}&categoryId=${category.id}&${searchstring}';"<c:if test="${oprt=='create'}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"></div>
			</shiro:hasPermission>
			<shiro:hasPermission name="core:special:copy">
			<div class="in-btn"><input type="button" value="<s:message code="copy"/>" onclick="location.href='create.do?id=${bean.id}&${searchstring}';"<c:if test="${oprt=='create'}"> disabled="disabled"</c:if>/></div>
			</shiro:hasPermission>
      <shiro:hasPermission name="core:info:list">
      <c:url var="infoListUrl" value="../info/list.do">
        <c:param name="search_CONTAIN_JinfoSpecials.Jspecial.title" value="${bean.title}"/>
      </c:url>
      <div class="in-btn"><input type="button" value="<s:message code="special.infoList"/>" onclick="location.href='${infoListUrl}';"<c:if test="${oprt=='create'}"> disabled="disabled"</c:if>/></div>
      </shiro:hasPermission>
			<shiro:hasPermission name="core:special:delete">
			<div class="in-btn"><input type="button" value="<s:message code="delete"/>" onclick="if(confirmDelete()){location.href='delete.do?ids=${bean.id}&${searchstring}';}"<c:if test="${oprt=='create'}"> disabled="disabled"</c:if>/></div>
			</shiro:hasPermission>
			<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="prev"/>" onclick="location.href='edit.do?id=${side.prev.id}&position=${position-1}&${searchstring}';"<c:if test="${empty side.prev}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"><input type="button" value="<s:message code="next"/>" onclick="location.href='edit.do?id=${side.next.id}&position=${position+1}&${searchstring}';"<c:if test="${empty side.next}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="return"/>" onclick="location.href='list.do?${searchstring}';"/></div>
      <div style="clear:both;"></div>
    </td>
  </tr>
  <c:set var="colCount" value="${0}"/>
  <c:forEach var="field" items="${model.enabledFields}">
  <c:if test="${colCount%2==0||!field.dblColumn}"><tr></c:if>
  <td class="in-lab" width="15%"><c:if test="${field.required}"><em class="required">*</em></c:if><c:out value="${field.label}"/>:</td>
  <td<c:if test="${field.type!=50}"> class="in-ctt"</c:if><c:choose><c:when test="${field.dblColumn}"> width="35%"</c:when><c:otherwise> width="85%" colspan="3"</c:otherwise></c:choose>>
  <c:choose>
  <c:when test="${field.custom}">
    <tags:feild_custom bean="${bean}" field="${field}"/>
  </c:when>
  <c:otherwise>
  <c:choose>
  <c:when test="${field.name eq 'title'}">
    <c:set var="style_width">width:<c:out value="${field.customs['width']}" default="500"/>px;</c:set>
    <f:text name="title" value="${bean.title}" class="required" maxlength="150" style="${style_width}"/>
  </c:when>
  <c:when test="${field.name eq 'metaKeywords'}">
    <c:set var="style_width">width:<c:out value="${field.customs['width']}" default="500"/>px;</c:set>
    <f:text name="metaKeywords" value="${bean.metaKeywords}" maxlength="150" style="${style_width}"/>
  </c:when>
  <c:when test="${field.name eq 'metaDescription'}">
    <c:set var="style_width">width:<c:out value="${field.customs['width']}" default="500"/>px;</c:set>
    <c:set var="style_height">height:<c:out value="${field.customs['height']}" default="80"/>px;</c:set>
    <f:textarea name="metaDescription" value="${bean.metaDescription}" maxlength="255" style="${style_width}${style_height}"/>
  </c:when>
  <c:when test="${field.name eq 'category'}">
   	<select name="categoryId" class="required">
   		<f:options items="${categoryList}" itemValue="id" itemLabel="name" selected="${category.id}"/>
   	</select>
  </c:when>
  <c:when test="${field.name eq 'creationDate'}">
    <input type="text" name="creationDate" value="<fmt:formatDate value="${bean.creationDate}" pattern="yyyy-MM-dd'T'HH:mm:ss"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-ddTHH:mm:ss'});" class="${oprt=='edit' ? 'required' : ''}" style="width:180px;"/></td>
  </c:when>
  <c:when test="${field.name eq 'model'}">
    <select name="modelId" class="required" onchange="location.href='${oprt=='edit' ? 'edit' : 'create'}.do?id=${bean.id}&modelId='+$(this).val()+'&${searchstring}';">
      <f:options items="${modelList}" itemValue="id" itemLabel="name" selected="${model.id}"/>
    </select>
  </c:when>
  <c:when test="${field.name eq 'specialTemplate'}">
    <f:text id="specialTemplate" name="specialTemplate" value="${bean.specialTemplate}" maxlength="255" style="width:160px;"/><input id="specialTemplateButton" type="button" value="<s:message code='choose'/>"/>
    <script type="text/javascript">
    $(function(){
      Cms.f7.template("specialTemplate",{
        settings: {"title": "<s:message code="webFile.chooseTemplate"/>"}
      });
    });
    </script>
  </c:when>
  <c:when test="${field.name eq 'recommend'}">
   	<label><f:radio name="recommend" value="true" checked="${bean.recommend}" class="required" /><s:message code="yes"/></label>
   	<label><f:radio name="recommend" value="false" checked="${bean.recommend}" default="false" class="required" /><s:message code="no"/></label>
  </c:when>
  <c:when test="${field.name eq 'views'}">
    <f:text name="views" value="${oprt=='edit' ? bean.views : '0'}" class="required digit" style="width:180px;"/></td>
  </c:when>
  <c:when test="${field.name eq 'smallImage'}">
	  <tags:image_upload name="smallImage" value="${bean.smallImage}" width="${field.customs['imageWidth']}" height="${field.customs['imageHeight']}" watermark="${field.customs['imageWatermark']}" scale="${field.customs['imageScale']}"/>
  </c:when>
  <c:when test="${field.name eq 'largeImage'}">
    <tags:image_upload name="largeImage" value="${bean.largeImage}" width="${field.customs['imageWidth']}" height="${field.customs['imageHeight']}" watermark="${field.customs['imageWatermark']}" scale="${field.customs['imageScale']}"/>
  </c:when>  
  <c:when test="${field.name eq 'video'}">
    <div>
      <span style="padding:0 7px;"><s:message code="fileName"/>:</span><f:text id="videoName" name="videoName" value="${bean.videoName}" maxlength="255" style="width:420px;"/>
    </div>
    <div style="padding-top:3px;">
      <span style="padding:0 7px;"><s:message code="fileUrl"/>:</span><f:text id="video" name="video" value="${bean.video}" maxlength="255" style="width:420px;"/>
    </div>
    <div style="padding-top:3px;">
      <span style="padding:0 7px;"><input id="f_video" name="f_vedio" type="file" size="23" style="width:235px;"/></span> <input type="button" onclick="uploadVideo('video',this)" value="<s:message code="upload"/>"/>
    </div>
  </c:when>
    <c:when test="${field.name eq 'files'}">
    <textarea id="filesTemplateArea" style="display:none;">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0;border-top:1px solid #ccc;">
        <tbody>
        <tr>
          <td>
            <div style="padding-top:3px;">
              <span style="padding:0 7px;"><s:message code="fileName"/>:</span><f:text id="files{0}Name" name="filesName" value="" maxlength="255" style="width:420px;"/>
            </div>
            <div style="padding-top:3px;">
              <span style="padding:0 7px;"><s:message code="fileUrl"/>:</span><f:text id="files{0}" name="filesFile" value="" maxlength="255" style="width:420px;"/>
            </div>
            <div style="padding-top:3px;">
              <span style="padding:0 7px;"><s:message code="fileLength"/>:</span><f:text id="files{0}Length" name="filesLength" value="" class="{digits:true,max:2147483647}" maxlength="10" style="width:80px;"/>
              <input id="f_files{0}" name="f_files{0}" type="file" size="23" style="width:235px;"/> <input type="button" onclick="uploadFile('files{0}',this)" value="<s:message code="upload"/>"/>
            </div>
          </td>
          <td width="10%" align="center">
            <div><input type="button" value="<s:message code='delete'/>" onclick="filesRemove(this);"></div>
            <div><input type="button" value="<s:message code='moveUp'/>" onclick="filesMoveUp(this);"></div>
            <div><input type="button" value="<s:message code='moveDown'/>" onclick="filesMoveDown(this);"></div>
          </td>
        </tr>
        </tbody>
      </table>
    </textarea>  
    <script type="text/javascript">
    var fileRowIndex = 0;
    <c:if test="${!empty bean && fn:length(bean.files) gt 0}">
    fileRowIndex = ${fn:length(bean.files)};
    </c:if>
    var fileRowTemplate = $.format($("#filesTemplateArea").val());
    function addFileRow() {
      $(fileRowTemplate(fileRowIndex++)).appendTo("#filesContainer");
    }
    $(function() {
      if(fileRowIndex==0) {
        <c:if test="${oprt=='create'}">
        addFileRow(fileRowIndex);
        </c:if>
      }
    });
    function filesRemove(button) {
      var toMove = $(button).parent().parent().parent().parent().parent();
      toMove.remove();
    }
    function filesMoveUp(button) {
      var toMove = $(button).parent().parent().parent().parent().parent();
      toMove.prev().before(toMove);
    }
    function filesMoveDown(button) {
      var toMove = $(button).parent().parent().parent().parent().parent();
      toMove.next().after(toMove);
    }
    </script>
    <input type="button" value="<s:message code='addRow'/>" onclick="addFileRow();"/>
    <div id="filesContainer">
      <c:forEach var="item" items="${bean.files}" varStatus="status">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0;border-top:1px solid #ccc;">
        <tbody>
        <tr>
          <td>
            <div style="padding-top:3px;">
             <span style="padding:0 7px;"><s:message code="fileName"/>:</span><f:text id="files${status.index}Name" name="filesName" value="${item.name}" maxlength="255" style="width:420px;"/>
            </div>
            <div style="padding-top:3px;">
              <span style="padding:0 7px;"><s:message code="fileUrl"/>:</span><f:text id="files${status.index}" name="filesFile" value="${item.file}" maxlength="255" style="width:420px;"/>
            </div>
            <div style="padding-top:3px;">
              <span style="padding:0 7px;"><s:message code="fileLength"/>:</span><f:text id="files${status.index}Length" name="filesLength" value="${item.length}" class="{digits:true,max:2147483647}" maxlength="10" style="width:80px;"/>
              <input id="f_files${status.index}" name="f_files${status.index}" type="file" size="23" style="width:235px;"/> <input type="button" onclick="uploadFile('files${status.index}',this)" value="<s:message code="upload"/>"/>
            </div>
          </td>
          <td width="10%" align="center">
            <div><input type="button" value="<s:message code='delete'/>" onclick="filesRemove(this);"></div>
            <div><input type="button" value="<s:message code='moveUp'/>" onclick="filesMoveUp(this);"></div>
            <div><input type="button" value="<s:message code='moveDown'/>" onclick="filesMoveDown(this);"></div>
          </td>
        </tr>
        </tbody>
      </table>
      </c:forEach>
    </div>
  </c:when>
  <c:when test="${field.name eq 'images'}">
    <textarea id="imagesTemplateArea" style="display:none;">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0;border-top:1px solid #ccc;">
      <tbody>
      <tr>
        <td colspan="3">
          <div style="margin-top:2px;padding-right:20px;">
            &lt;textarea name="imagesText" style="width:100%;height:45px;"&gt;&lt;/textarea&gt;
          </div>
        </td>
      </tr>
      <tr>
        <td width="45%">
          <div style="margin-top:2px;">
            <f:text id="imagesImage{0}" name="imagesImage" value="" onchange="fn_imagesImage{0}(this.value);" style="width:180px;"/>
            <input type="button" value="<s:message code='choose'/>" disabled="disabled"/>
          </div>
          <div style="margin-top:2px;"><input type="file" id="f_imagesImage{0}" name="f_imagesImage" size="23" style="width:235px;"/></div>
          <div style="margin-top:2px;">
            <table class="upload-table" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td><s:message code="width"/>: <f:text id="w_imagesImage{0}" value="${field.customs['imageWidth']}" default="1500" style="width:70px;"/></td>
                <td><label><input type="checkbox" id="s_imagesImage{0}"<c:if test="${empty field.customs['imageScale'] || field.customs['imageScale']=='true'}"> checked="checked"</c:if>/><s:message code="scale"/></label></td>
                <td><input type="button" onclick="uploadImg('imagesImage{0}',this);" value="<s:message code='upload'/>"/></td>
              </tr>
              <tr>
                <td><s:message code="height"/>: <f:text id="h_imagesImage{0}" value="${field.customs['imageHeight']}" default="" style="width:70px;"/></td>
                <td><label><input type="checkbox" id="wm_imagesImage{0}"<c:if test="${empty field.customs['imageWatermark'] || field.customs['imageWatermark']=='true'}"> checked="checked"</c:if>/><s:message code="watermark"/></label></td>
                <td><input type="button" onclick="imgCrop('imagesImage{0}');" value="<s:message code='crop'/>"/></td>
              </tr>
            </table>
            <f:hidden name="imagesName" value=""/>
            <f:hidden id="e_imagesImage{0}" value="${(!empty field.customs['exact']) ? field.customs['exact'] : 'false'}"/>
            <f:hidden id="t_imagesImage{0}" value="${(!empty field.customs['thumbnail']) ? field.customs['thumbnail'] : 'true'}"/>
            <f:hidden id="tw_imagesImage{0}" value="${(!empty field.customs['thumbnailWidth']) ? field.customs['thumbnailWidth'] : '116'}"/>
            <f:hidden id="th_imagesImage{0}" value="${(!empty field.customs['thumbnailHeight']) ? field.customs['thumbnailHeight'] : '77'}"/>
          </div>
        </td>
        <td width="45%" align="center" valign="middle">
          <img id="img_imagesImage{0}" style="display:none;"/>
          <script type="text/javascript">
            function fn_imagesImage{0}(src) {
              Cms.scaleImg("img_imagesImage{0}",300,100,src);
            };
            fn_imagesImage{0}("");
          </script>
        </td>
        <td width="10%" align="center">
          <div><input type="button" value="<s:message code='delete'/>" onclick="imagesRemove(this);"></div>
          <div><input type="button" value="<s:message code='moveUp'/>" onclick="imagesMoveUp(this);"></div>
          <div><input type="button" value="<s:message code='moveDown'/>" onclick="imagesMoveDown(this);"></div>
          <div><input type="button" value="<s:message code='addRow'/>" onclick="addImageRow(this);"/></div>
        </td>
      </tr>
      </tbody>
    </table>
    </textarea>
    <script type="text/javascript">
    var imageRowIndex = 0;
    <c:if test="${!empty bean && fn:length(bean.images) gt 0}">
    imageRowIndex = ${fn:length(bean.images)};
    </c:if>
    var imageRowTemplate = $.format($("#imagesTemplateArea").val());
    function addImageRow(button) {
      if(button) {
        $(imageRowTemplate(imageRowIndex++)).insertAfter($(button).parent().parent().parent().parent().parent());
      } else {
        $(imageRowTemplate(imageRowIndex++)).appendTo("#imagesContainer");
      }
    }
    $(function() {
      if(imageRowIndex==0) {
        <c:if test="${oprt=='create'}">
        addImageRow(imageRowIndex);
        </c:if>
      }
    });
    function imagesRemove(button) {
      var toMove = $(button).parent().parent().parent().parent().parent();
      toMove.remove();
    }
    function imagesMoveUp(button) {
      var toMove = $(button).parent().parent().parent().parent().parent();
      toMove.prev().before(toMove);
    }
    function imagesMoveDown(button) {
      var toMove = $(button).parent().parent().parent().parent().parent();
      toMove.next().after(toMove);
    }
    </script>
    <input type="button" value="<s:message code='addRow'/>" onclick="addImageRow();"/>
    <div id="imagesContainer">
    <c:forEach var="item" items="${bean.images}" varStatus="status">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:5px 0;border-top:1px solid #ccc;">
        <tbody>
        <tr>
          <td colspan="3">
            <div style="margin-top:2px;padding-right:20px;">
              <f:textarea name="imagesText" value="${item.text}" style="width:100%;height:45px;"/>
            </div>
          </td>
        </tr>
        <tr>
          <td width="45%">
            <div style="margin-top:2px;">
              <f:text id="imagesImage${status.index}" name="imagesImage" value="${item.image}" onchange="fn_imagesImage${status.index}(this.value);" style="width:180px;"/>
              <input type="button" value="<s:message code='choose'/>" disabled="disabled"/>
            </div>
            <div style="margin-top:2px;"><input type="file" id="f_imagesImage${status.index}" name="f_imagesImage" size="23" style="width:235px;"/></div>
            <div style="margin-top:2px;">
            <table class="upload-table" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td><s:message code="width"/>: <f:text id="w_imagesImage${status.index}" value="${field.customs['imageWidth']}" default="1500" style="width:70px;"/></td>
                <td><label><input type="checkbox" id="s_imagesImage${status.index}"<c:if test="${empty field.customs['imageScale'] || field.customs['imageScale']=='true'}"> checked="checked"</c:if>/><s:message code="scale"/></label></td>
                <td><input type="button" onclick="uploadImg('imagesImage${status.index}',this);" value="<s:message code='upload'/>"/></td>
              </tr>
              <tr>
                <td><s:message code="height"/>: <f:text id="h_imagesImage${status.index}" value="${field.customs['imageHeight']}" default="" style="width:70px;"/></td>
                <td><label><input type="checkbox" id="wm_imagesImage${status.index}"<c:if test="${empty field.customs['imageWatermark'] || field.customs['imageWatermark']=='true'}"> checked="checked"</c:if>/><s:message code="watermark"/></label></td>
                <td><input type="button" onclick="imgCrop('imagesImage${status.index}');" value="<s:message code='crop'/>"/></td>
              </tr>
            </table>
            <f:hidden name="imagesName" value=""/>
            <f:hidden id="e_imagesImage${status.index}" value="${(!empty field.customs['exact']) ? field.customs['exact'] : 'false'}"/>
            <f:hidden id="t_imagesImage${status.index}" value="${(!empty field.customs['thumbnail']) ? field.customs['thumbnail'] : 'true'}"/>
            <f:hidden id="tw_imagesImage${status.index}" value="${(!empty field.customs['thumbnailWidth']) ? field.customs['thumbnailWidth'] : '116'}"/>
            <f:hidden id="th_imagesImage${status.index}" value="${(!empty field.customs['thumbnailHeight']) ? field.customs['thumbnailHeight'] : '77'}"/>
            </div>
          </td>
          <td width="45%" align="center" valign="middle">
            <img id="img_imagesImage${status.index}" style="display:none;"/>
            <script type="text/javascript">
              function fn_imagesImage${status.index}(src) {
                Cms.scaleImg("img_imagesImage${status.index}",300,100,src);
              };
              fn_imagesImage${status.index}("${item.image}");
            </script>
          </td>
          <td width="10%" align="center">
            <div><input type="button" value="<s:message code='delete'/>" onclick="imagesRemove(this);"></div>
            <div><input type="button" value="<s:message code='moveUp'/>" onclick="imagesMoveUp(this);"></div>
            <div><input type="button" value="<s:message code='moveDown'/>" onclick="imagesMoveDown(this);"></div>
            <div><input type="button" value="<s:message code='addRow'/>" onclick="addImageRow(this);"/></div>
          </td>
        </tr>
        </tbody>
      </table>
    </c:forEach>
    </div>
  </c:when>
  <c:otherwise>
    System field not found: '${field.name}'
  </c:otherwise>
  </c:choose>
  </c:otherwise>
  </c:choose>
  </td><c:if test="${colCount%2==1||!field.dblColumn}"></tr></c:if>
  <c:if test="${field.dblColumn}"><c:set var="colCount" value="${colCount+1}"/></c:if>
  </c:forEach>
	<tr>
    <td colspan="4" class="in-opt">
      <div class="in-btn"><input type="submit" value="<s:message code="save"/>"/></div>
      <div class="in-btn"><input type="submit" value="<s:message code="saveAndReturn"/>" onclick="$('#redirect').val('list');"/></div>
      <c:if test="${oprt=='create'}">
      <div class="in-btn"><input type="submit" value="<s:message code="saveAndCreate"/>" onclick="$('#redirect').val('create');"/></div>
      </c:if>
      <div style="clear:both;"></div>
    </td>
  </tr>
</table>
</form>
</body>
</html>