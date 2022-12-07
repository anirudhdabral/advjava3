<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.Query"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="database.ProductDetails"%>
<%@page import="java.sql.Blob"%>
<%@page import="javax.xml.bind.DatatypeConverter"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Welcome</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">
</head>
<body>
	<%
		if (session.getAttribute("username") == null) {
			response.sendRedirect("login.jsp");
		}
	%>

	<nav class="navbar justify-content-between"
		style="background-color: #e3f2fd;">
		<h1>Product Management Tool</h1>
		<form class="form-inline" action="LogoutServlet">
			<span class="p-1">Welcome @${username}</span><input type="submit"
				class="btn btn-outline-danger" value="Logout">
		</form>
	</nav>
	${invalid}
	<div class="m-1">
		<div class="p-4">

			<form action="AddServlet" method="post" name="form"
				onsubmit="return numberValidation()" enctype="multipart/form-data">
				<div class="form-group row">
					<span class="p-3"><b>Please enter product details to add
							to stock</b></span>
				</div>
				<div class="form-group row">
					<label class="col-2">Title</label><input type="text" class="col-3"
						name="title" required />
				</div>
				<div class="form-group row">
					<label class="col-2">Quantity</label><input type="text"
						class="col-3" name="quantity" required />
				</div>
				<div class="form-group row">
					<label class="col-2">Size</label><input type="text" class="col-3"
						name="size" required />
				</div>
				<div class="form-group row">
					<label class="col-2">Image</label><input type="file" name="image"
						id="filess" required />
				</div>
				<div class="form-group row">
					<div class="col-sm-10">
						<input type="submit" class="btn btn-outline-success"
							value="Add to database" />
					</div>
				</div>
			</form>
			<div id="uploadError"></div>
		</div>



		<div class="table-responsive p-4">
			<table class="table table-bordered table-hover p-1">
				<thead class="thead-light" align="center">
					<th>Product ID</th>
					<th>Title</th>
					<th>Quantity</th>
					<th>Size</th>
					<th>Image</th>
					<th>Actions</th>
				</thead>
				<tbody align="center">
					<%
						try {
							SessionFactory factory = new Configuration().configure("product.cfg.xml").buildSessionFactory();
							Session dbsession = factory.openSession();
							String query = "from ProductDetails order by pid";
							Query q = dbsession.createQuery(query);
							List<ProductDetails> ls = q.list();
							int cnt = 1;
							for (ProductDetails pd : ls) {
					%>
					<tr>
						<td><%=pd.getPid()%></td>
						<td><%=pd.getTitle()%></td>
						<td><%=pd.getQuantity()%></td>
						<td><%=pd.getSize()%></td>
						<td>
							<%
								Blob blob = pd.getImage();
										byte arr[] = blob.getBytes(1, (int) blob.length());
										String encodedData = DatatypeConverter.printBase64Binary(arr);
							%> <img src="data:;base64,<%=encodedData%>" width="100"
							height="100" />
						</td>
						<td>
							<div class="btn-group btn-group-sm" role="group">
								<form action="EditServlet" method="get">
									<input type="hidden" name="ptid" value="<%=pd.getPid()%>" /> <input
										class="btn btn-outline-success" type="submit"
										style="border-radius: 5px 0px 0px 5px; border-right-style: dotted;"
										value="Edit" />
								</form>
								<form action="DeleteServlet" method="get">
									<input type="hidden" name="ptid" value="<%=pd.getPid()%>" /> <input
										class="btn btn-outline-danger" type="submit"
										style="border-radius: 0px 5px 5px 0px; border-left-style: dotted;"
										value="Delete" />
								</form>

							</div>
						</td>
					</tr>
					<%
						}
							dbsession.close();
							factory.close();
						} catch (Exception ex) {
							ex.printStackTrace();
						}
					%>
				</tbody>
			</table>
		</div>


	</div>


	<script>
		function numberValidation() {
			var quantity = document.form.quantity.value;
			var size = document.form.size.value;
			var fileUpload = document.form.image;
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