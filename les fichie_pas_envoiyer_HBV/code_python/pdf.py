from weasyprint import HTML

input_html = 'results/graphs/global/rapport_global_couverture.html'
output_pdf = 'results/graphs/global/rapport.pdf'

HTML(input_html).write_pdf(output_pdf)
print(f"✅ PDF créé avec succès : {output_pdf}")
