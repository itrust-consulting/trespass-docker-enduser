<%@ page session="false" contentType="application/xml; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'>
    <cas:authenticationSuccess>
		<cas:user>${fn:escapeXml(principal.id)}</cas:user>
		<cas:attributes>
			<c:forEach var="auth" items="${assertion.chainedAuthentications}">
				<c:forEach var="attr" items="${auth.principal.attributes}" >
					<c:if test="${not fn:endsWith(attr.key,'dn')}"><cas:${fn:escapeXml(attr.key)}>${fn:escapeXml(attr.value)}</cas:${fn:escapeXml(attr.key)}></c:if>
				</c:forEach>
			</c:forEach>
		</cas:attributes>
        <c:if test="${not empty pgtIou}">
            <cas:proxyGrantingTicket>${pgtIou}</cas:proxyGrantingTicket>
        </c:if>
        <c:if test="${fn:length(chainedAuthentications) > 0}">
            <cas:proxies>
                <c:forEach var="proxy" items="${chainedAuthentications}" varStatus="loopStatus" begin="0" end="${fn:length(chainedAuthentications)}" step="1">
                    <cas:proxy>${fn:escapeXml(proxy.principal.id)}</cas:proxy>
                </c:forEach>
            </cas:proxies>
        </c:if>
    </cas:authenticationSuccess>
</cas:serviceResponse>
