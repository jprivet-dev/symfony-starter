<?php

namespace App\Form;

use App\Dto\PriceBcMathNumberDto;
use App\Dto\PriceFloatDto;
use BcMath\Number;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\CallbackTransformer;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PriceFloatType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder->add('price', NumberType::class, ['label' => 'Price — GreaterThanOrEqual("0.01")']);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => PriceFloatDto::class]);
    }
}
