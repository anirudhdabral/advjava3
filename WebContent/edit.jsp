<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Query"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="database.ProductDetails"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">
</head>
<body>

	<%
		int pid = Integer.parseInt(request.getParameter("product_id").trim());
		SessionFactory factory = new Configuration().configure("product.cfg.xml").buildSessionFactory();
		Session dbsession = factory.openSession();
		ProductDetails p = (ProductDetails) dbsession.get(ProductDetails.class, pid);
	%>
	<nav class="navbar justify-content-between"
		style="background-color: #e3f2fd;">
		<h1>Edit product details</h1>
		<form class="form-inline" action="LogoutServlet">
			<span class="p-1">Welcome @${username}</span><input type="submit"
				class="btn btn-outline-danger" value="Logout">
		</form>
	</nav>
	<div class="m-1 p-4">

		<form action="UpdateServlet" method="post"
			onsubmit="return numberValidation()" enctype='multipart/form-data'>
			<div class="form-group row">
				<span class="p-3"><b>Please enter product details to be
						updated</b></span>
			</div>
			<div class="form-group row">
				<label class="col-2">Product ID</label><input type="text"
					class="col-3" name="pidq" value="<%=p.getPid()%>" readonly />
			</div>
			<div class="form-group row">
				<label class="col-2">Title</label><input type="text" class="col-3" value="<%=p.getTitle()%>"
					name="title" required />
			</div>
			<div class="form-group row">
				<label class="col-2">Quantity</label><input type="text" value="<%=p.getQuantity()%>"
					class="col-3" name="quantity" required />
			</div>
			<div class="form-group row">
				<label class="col-2">Size</label><input type="text" class="col-3" value="<%=p.getSize()%>"
					name="size" required />
			</div>
			<div class="form-group row">
				<label class="col-2">Image</label><input type="file" name="img"
					id="filess" />
			</div>
			<div class="form-group row">
				<div class="col-sm-10">
					<input type="submit" class="btn btn-outline-success"
						value="Commit Edit" />
				</div>
			</div>
		</form>
		<div id="uploadError"></div>
	</div>
	<script>
		function numberValidation() {
			var quantity = document.form.quantity.value;
			var size = document.form.size.value;
			var fileUpload = document.form.img;
			var allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
			var filesize = parseFloat((fileUpload.files[0].size / 1024)/1024);

			if (isNaN(quantity)) {
				document.getElementById("uploadError").innerHTML = "<div id=\"invalid\"class=\"alert alert-danger\" role=\"alert\">\r\n"
						+ "					<span>Quantity must be a number!</span>\r\n"
						+ "				</div>";
				return false;
			} else if (isNaN(size)) {
				document.getElementById("uploadError").innerHTML = "<div id=\"invalid\"class=\"alert alert-danger\" role=\"alert\">\r\n"
						+ "					<span>Size must be a number!</span>\r\n"
						+ "				</div>";
				return false;
			} else if (!allowedExtensions.exec(fileUpload.value)) {
				document.getElementById("uploadError").innerHTML = "<div id=\"invalid\"class=\"alert alert-danger\" role=\"alert\">\r\n"
						+ "					<span>Invalid file type. Only jpeg/jpg.png/gif are allowed.</span>\r\n"
						+ "				</div>";
				return false;
			} else if (filesize > 1) {
				document.getElementById("uploadError").innerHTML = "<div id=\"invalid\"class=\"alert alert-danger\" role=\"alert\">\r\n"
						+ "					<span>Image size too big! Max size: 1MB.</span>\r\n"
						+ "				</div>";
				return false;
			}

			return true;
		}
	</script>

</body>
</html>