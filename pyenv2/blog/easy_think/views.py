from django.shortcuts import render

from datetime import datetime
from django.http import HttpResponse
from easy_think.models import EasyThink
# Create your views here.

def home(request):
    return HttpResponse("Yeah, Easy Think!")

def detail(request, args):
    post = EasyThink.objects.all()[int(args)]
    str = ("title = %s, category = %s, date_time = %s, content = %s"
           % (post.title, post.category, post.date_time, post.content))
    return HttpResponse(str)

def show(request):
    return render(request, 'show.html', {'current_time': datetime.now()})
