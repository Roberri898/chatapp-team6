<%--
  Copyright 2017 Google Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--%>
<%@ page import="java.util.List" %>
<%@ page import="codeu.model.data.Conversation" %>
<%@ page import="codeu.model.data.User" %>

<!DOCTYPE html>
<html>
<head>
  <title>Conversations</title>
  <link rel="stylesheet" href="/css/main.css">
</head>
<body>

  <%@ include file="/nav.jsp" %>

  <div id="container">

    <% if(request.getAttribute("error") != null){ %>
        <h2 style="color:red"><%= request.getAttribute("error") %></h2>
    <% } %>

    <% if(request.getSession().getAttribute("user") != null){ %>
      <h1>New Conversation</h1>
      <form action="/conversations" method="POST">
          <div class="form-group">
            <label class="form-control-label">Title:</label>
          <input type="text" name="conversationTitle">
        </div>
         <input type="checkbox" name="private" value="Private">Make private<br>

        <button type="submit">Create</button>
      </form>

      <hr/>
    <% } %>

    <h1>Conversations</h1>

    <%
    List<Conversation> conversations =
      (List<Conversation>) request.getAttribute("conversations");
    if(conversations == null || conversations.isEmpty()){
    %>
      <p>Create a conversation to get started.</p>
    <%
    }
    else{
    %>
      <ul class="mdl-list">
      <%for(Conversation conversation : conversations){%>
        <% if(!conversation.getPrivacy()){ %>
          <li><a href="/chat/<%= conversation.getTitle() %>"><%= conversation.getTitle() %></a></li>
        <%}else{%>
          <% if(request.getSession().getAttribute("user") != null){ %>
            <%String[] participants = conversation.getParticipants();%>
            <%for(int i = 0; i < participants.length; i++){%>
              <% if(participants[i].equals(request.getSession().getAttribute("user"))){ %>
                <li><a href="/chat/<%= conversation.getTitle() %>"><%= conversation.getTitle()+"(private)" %></a></li>
                <%if(true) break;%>
              <%}%>
            <%}%>
          <%}%>
        <%}%>
      <%}%>
      </ul>
    <%}%>
    <hr/>

    <h1>Direct Messages</h1>

    <%
    String username = (String) request.getSession().getAttribute("user");
    List<User> users =
      (List<User>) request.getAttribute("users");
    if(users == null || users.isEmpty()){
    %>
      <p>No users found. Something went terribly wrong. </p>
    <%
    }
    else{
    %>
      <ul class="mdl-list">
    <%
      for(User user : users){
        if (!user.getName().equals(username)) {
    %>
      <li><a href="/chat/<%= user.getName() %>">
        <%= user.getName() %></a></li>
    <%
        }
      }
    %>
      </ul>
    <%
    }
    %>
    <hr/>

  </div>
</body>
</html>
